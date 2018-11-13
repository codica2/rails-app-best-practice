class LeadDecorator < Draper::Decorator

  include ActionView::Helpers::NumberHelper

  delegate_all

  def offered_price
    number_to_currency(object.offered_price, unit: ExchangeRate.base_currency, precision: 0, format: price_format, delimiter: price_divider)
  end

  private

  def price_format
    I18n.default_locale == :fr ? '%n %u' : '%u %n'
  end

  def price_divider
    I18n.default_locale == :en ? ',' : ' '
  end

end
