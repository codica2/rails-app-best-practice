module LeadHelper

  def lead_price(listing)
    current = CalculateCurrency.call(price: listing.price, currency: @current_currency)
    delimiter = I18n.default_locale == :en ? ',' : ' '
    price = number_with_delimiter(current[:price], delimiter: delimiter)
    if listing.price.present? && listing.price.positive?
      sanitize("#{current[:currency]} #{price}")
    else
      t('home.index.negotiable')
    end
  end

  def lead_whatsapp_link(phone_number)
    "https://api.whatsapp.com/send?phone=#{phone_number.phone}"
  end

end
