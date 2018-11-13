module InvestorPerformer

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

  end

  def sub_investor?
    Investor.select { |i| i.email == email && i.created_at < created_at }.present?
  end

  def default_values
    self.payment_method ||= :no_data
    self.wire_transfer_fee ||= 20
  end

  def raw_payment_method
    Investor.payment_methods[payment_method]
  end

  def different_investments?
    investments.map(&:investment_type).uniq.count >= 1
  end

  def box
    return nil if box_url.blank?

    box_url.include?('http') ? box_url : 'http://' + box_url
  end

end
