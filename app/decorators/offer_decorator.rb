class OfferDecorator < Draper::Decorator

  include ActionView::Helpers::NumberHelper

  delegate_all

  def creation_date
    object.created_at.strftime('%d/%m/%Y')
  end

  def title
    object.target.decorate.title
  end

  def recipients_count
    recipients = object.leads.count
    result = object.with_sms ? "#{recipients} SMS" : nil
    [result, "#{recipients} EMAILS"].reject(&:blank?).join(' / ')
  end

  def price
    number_to_currency(object.price, unit: '$')
  end

  def emails_delivery_status
    "#{object.emails_delivered} / #{object.lead_offers.count}"
  end

  def sms_delivery_status
    return unless object.with_sms?

    "#{object.sms_delivered} / #{object.lead_offers.count}"
  end

end
