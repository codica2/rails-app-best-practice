class InvestorForm
  include ActiveModel::Model

  validates :name,  presence: { message: "Can't be blank" }
  validate  :email_uniqueness, if: :email_validation

  validates :email,
            presence: { message: "Can't be blank" },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'Not a valid email address' }

  validates :phone_number,
            presence: {                              message: "Can't be blank" },
            format:   { with: /\A\+?[\d]+[\d\-]+\z/, message: 'Invalid phone number' },
            length:   { minimum: 10, maximum: 15,    message: 'The amount of characters is between 10 and 15' }

  # attr_accessor :check, :wire_transfer
  attr_reader :params, :address

  delegate :check, :wire_transfer, :connected?, :persisted?, :inactive?,
           :investor_viewers, :viewer_investors, :investor_group, :address, :inactive_investor_contact, to: :investor

  delegate :address_attributes=, to: :investor, prefix: false
  delegate :inactive_investor_contact_attributes=, to: :investor, prefix: false

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Investor')
  end

  def initialize(instance = nil)
    @investor = instance
    investor.build_address unless investor.address
    investor.build_inactive_investor_contact if investor && investor.inactive_investor_contact.nil?

    investor_params_array.each do |key|
      singleton_class.send :attr_accessor, key
      singleton_class.send :delegate, key, to: :investor
    end
  end

  def submit(params)
    @params = params
    investor.assign_attributes(investor_params)

    if valid?
      investor.save!
      true
    else
      false
    end
  end

  def investor
    @investor ||= Investor.new
  end

  private

  def investor_params
    params.require(:investor).permit(:id, :name, :phone_number, :email, :password, :occupation, :birthday, :red_mark,
                                     :investor_group_id, :accredited_investor, :itin_ssn, :box_url, :connected,
                                     :wire_transfer_fee, :avatar, :mail_validation, :inactive,
                                     address_attributes: %i[id attention institution address_1 address_2 address_3 city
                                                            state postal_code country investor_id],
                                     inactive_investor_contact_attributes: %i[investor_id name email phone_number comments])
  end

  def investor_params_array
    [:id, :name, :phone_number, :email, :password, :occupation, :birthday, :red_mark,
     :investor_group_id, :accredited_investor, :itin_ssn, :box_url, :connected,
     :wire_transfer_fee, :avatar, :email_validation, :inactive]
  end

end
