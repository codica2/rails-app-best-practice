class Investor < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :timeoutable, timeout_in: 15.minutes

  after_initialize :default_values

  mount_uploader :avatar, AvatarUploader

  has_one :wire_transfer,            dependent: :destroy
  has_one :check,                    dependent: :destroy
  has_one :address,                  dependent: :destroy
  has_many :documents,               dependent: :destroy
  has_many :admin_distributions,     dependent: :destroy
  has_many :investor_viewers,        dependent: :destroy
  has_many :investment_datas,        dependent: :destroy
  has_many :loan_datas,              dependent: :destroy
  has_many :opportunities_reports,   dependent: :destroy

  has_many :loans,                   through: :loan_datas,            source: :loan
  has_many :investments,             through: :investment_datas,      source: :investment
  has_many :viewers,                 through: :investor_viewers,      source: :viewer
  has_many :opportunities,           through: :opportunities_reports, source: :opportunity

  has_many :viewer_investors,        class_name: 'InvestorViewer', foreign_key: :viewer_id, dependent: :destroy
  has_many :notifications, as: :human

  belongs_to :investor
  belongs_to :investor_group

  has_many :related_investors,           dependent: :destroy
  has_many :backwards_related_investors, class_name: 'RelatedInvestor',
                                         foreign_key: 'related_investor_id',
                                         dependent: :destroy

  validates :name, presence: { message: "Can't be blank"}
  validates :email, presence: { message: "Can't be blank"}, uniqueness: { message: "Has already been taken"},
                                                            email_format: true, if: :email_validation
  validates :phone_number, presence: { message: "Can't be blank"}, format: { with: /\A\+?[\d]+[\d\-]+\z/, message: 'Invalid phone number'},
            length: { minimum: 10, maximum: 15, message: 'The amount of characters is between 10 and 15' }

  validate  :email_valid
  validate  :birthday_valid

  enum payment_method: [:wire_transfer, :check, :no_data]

  accepts_nested_attributes_for :address

  accepts_nested_attributes_for :related_investors, :backwards_related_investors, reject_if: proc { |a| a['related_investor_id'].blank? }

  scope :real, -> { where(viewer: false) }
  scope :distributions, -> (year, quarter, direction) { real.real.joins(:admin_distributions).where('admin_distributions.year = ? AND admin_distributions.quarter = ?', year, quarter).order    ("admin_distributions.payed #{direction}, name ASC") }
  scope :viewers, -> { where(viewer: true) }

  after_update :update_managers

  paginates_per 20

  def my_manager?(investor)
    self.investor_group.try(:manager_ids).try(:include?, investor.id)
  end

  def managers
    investor_viewers.where(viewer_type: 2).map { |iv| iv.investor }.uniq
  end

  def viewed_investors
    ids = viewer_investors.map(&:investor_id)
    ids << id unless self.viewer?
    Investor.where(id: ids)
  end

  def regular_viewers
    self.investor_viewers.where(viewer_type: 0).map(&:viewer)
  end

  def country
    address.try(:country)
  end

  def is_connected?(investor)
    email == investor.email && id != investor.id && investor.connected?
  end

  def uniq_email?
    email_validation
  end

  def has_connected_investor?
    Investor.where(email: email).where(connected: true).any? ? true : false
  end

  def birthday_valid
    if birthday.present? && (birthday <= 125.years.ago || birthday > Time.now)
      errors.add(:birthday, ' is invalid')
    end
  end

  def regular_investors
    InvestorViewer.where(viewer_id: id, viewer_type: 0)
  end

  def sub_investors
    InvestorViewer.where(viewer_id: id, viewer_type: 1)
  end

  def managed_investors
    InvestorViewer.where(viewer_id: id, viewer_type: 2)
  end

  def managed_group_name
    InvestorGroup.select { |ig| ig.manager_ids.include?(id) }.first.name
  end

  def sub_investor?
    Investor.select { |i| i.email == email && i.created_at < created_at }.present?
  end

  def total(value, type, action = :sum)
    investment_type = type == :development ? 0 : 1
    investment_datas.joins(:investment).where(['investments.investment_type = ?', investment_type])
                    .send(action, "investment_data.#{value}")
  end

  def total_final_distribution(type)
    result = 0
    investments.includes(:investment_datas).send(type).each do |investment|
      investment_data = investment.investment_datas.detect { |inv_data| inv_data.investor_id == id }
      final_distribution = investment_data.final_distribution_after_fee
      result += final_distribution if final_distribution
    end
    result
  end

  def default_values
    self.payment_method ||= :no_data
    self.wire_transfer_fee ||= 20
  end

  def raw_payment_method
    Investor.payment_methods[self.payment_method]
  end

  def different_investments?
    self.investments.map(&:investment_type).uniq.count > 1
  end

  def box
    if box_url.present?
      box_url.include?('http') ? box_url : 'http://' + box_url
    else
      nil
    end
  end

  def total_distribution(investment)
    investment_data = investment_datas.find { |investment_data| investment_data.investment_id == investment.id }
    if investment.development?
      if investment.distribution
        investment_data.invest_amount + investment_data.holding.round(2) * investment.distribution / 100
      else
        0
      end
    elsif investment.multi_family?
      investment.distribution_years.flat_map(&:distributions).map do |distribution|
        distribution.distribution_after_holding(investment_data)
      end.reject(&:nil?).inject(&:+)
    elsif investment.loan?
      loan_datas.find { |loan_data| loan_data.investment_id == investment.id }.loan_dividends.map(&:amount).inject(&:+)
    end
  end

end
