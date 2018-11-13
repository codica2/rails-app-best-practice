class CalculateCurrency < BaseService

  attr_reader :price, :currency, :rewert

  def initialize(options = {})
    @price = options[:price].to_i
    @currency = options[:currency]
    @rewert = options[:rewert] || nil
  end

  def call
    rate = get_rate(ExchangeRate.base_currency, Settings.currencies[currency])
    money = rate.present? ? get_price(rate) : price
    { currency: currency, price: money }
  end

  private

  def get_price(rate)
    rewert.present? ? (price / rate).floor : (rate * price).floor
  end

  def get_rate(from, to)
    Money.default_bank.get_rate(from, to)
  end

end
