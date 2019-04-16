class Investor < ApplicationRecord
  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Extensions ===========================================================
  enum payment_method: [:wire_transfer, :check, :no_data]
  enum investor_type: [:regular, :admin]

  include PgSearch
  include InvestorPerformer

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :timeoutable, timeout_in: 15.minutes

  mount_uploader :avatar, AvatarUploader

  # == Relationships ========================================================
  has_one :wire_transfer,            dependent: :destroy
  has_one :check,                    dependent: :destroy
  has_one :address,                  dependent: :destroy
  has_one :pie_chart,                through: :investor_dashboard
  has_one :inactive_investor_contact, dependent: :destroy

  # his viewers, managers, main connected investor
  has_many :investor_viewers,        dependent: :destroy
  # investors he manages, views, his connected investors
  has_many :viewer_investors,        class_name: 'InvestorViewer', foreign_key: :viewer_id, dependent: :destroy
  has_many :investor_dashboards,     dependent: :destroy
  has_many :documents,               dependent: :destroy
  has_many :admin_distributions,     dependent: :destroy
  has_many :equity_datas,        dependent: :destroy
  has_many :note_datas,              dependent: :destroy
  has_many :opportunities_reports,   dependent: :destroy
  has_many :notes,                   through: :note_datas,            source: :note
  has_many :equities, -> { distinct }, through: :equity_datas,      source: :equity
  has_many :viewers,                 through: :investor_viewers,      source: :viewer
  has_many :opportunities,           through: :opportunities_reports, source: :opportunity
  has_many :related_investors,           dependent: :destroy
  has_many :backwards_related_investors, class_name: 'RelatedInvestor',
                                         foreign_key: 'related_investor_id', dependent: :destroy

  belongs_to :investor_group, optional: true

  accepts_nested_attributes_for :address, :inactive_investor_contact

  # == Validations ==========================================================
  validates :name, :phone_number, presence: true

  validates :phone_number, format: { with: /\A\+?[\d]+[\d\-]+\z/ },
                           length: { in: 10..15 }, unless: proc { |investor| investor.phone_number.blank? }

  validates_confirmation_of :password, message: "Passwords don't match"
  validates :password, format: { with: /\A(?=.*?\d.*?\d)(?=.*[a-zA-Z]).{8,15}\z/, message: 'Password does not satisfy the requirements' }, allow_nil: true

  # == Scopes ===============================================================
  scope :real,                     -> { where(viewer: false).order(:name) }
  scope :viewers,                  -> { where(viewer: true) }

  pg_search_scope :search, against: %i[name], using: {
    tsearch: { prefix: true }
  }


  # == Callbacks ============================================================
  after_initialize :default_values
  after_save :update_dashboard, unless: -> { changes[:sign_in_count] || changes[:investor_group_id] }
  after_update :update_managers, if: -> { changes[:investor_group_id] }

  before_destroy :update_prime_investor!, prepend: true, if: :connected?
  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def profile_updated_notification
    AdminMailer.investor_update_profile(self, 'Profile was updated').deliver_now
  end

  def prime_connected_investor
    investor_viewers.connected.first&.viewer
  end

  def reset_tutorial
    self.tutorial_progress['/investor'] = false
    self.save
  end

  def investor_dashboard
    investor_dashboards.dollar.first
  end

  private

  def email_regexp
    /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  end

end
