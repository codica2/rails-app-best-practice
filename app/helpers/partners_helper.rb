module PartnersHelper

  def partner_activation(partner)
    partner.active? ? t('partners.extend_activation') : t('partners.activation')
  end

  def partner_company_types
    Partner.company_types.keys.map { |type| [I18n.t("partners.#{type}"), type] }
  end

  def partner_filter_active?(type, type_from_params)
    VehicleListing.car_types[type] == type_from_params || (type_from_params.blank? && type == VehicleListing.car_types.first.to_sym)
  end

  def partner_info?(partner)
    partner.address.present? || partner.website.present?
  end

  def partner_edit_page_title(redirect_url)
    redirect_url.present? ? I18n.t('partners.upgrade_my_profile') : I18n.t('partners.edit_my_profile')
  end

  def available_hours
    (0..23).map { |h| "#{h}:00" }
  end

  def logo_title(logo)
    logo.present? ? I18n.t('partners.form.change_logo') : I18n.t('partners.form.add_logo')
  end

  def get_premium_title(partner)
    partner.active? ? t('partners.extend_premium_account') : t('dashboard.menu.get_premium_account')
  end

  def working_hours(partner)
    work_html = ''
    partner.working_hours.each do |schedule|
      next unless schedule.completely_filled?
      work_html += "<li class='work'>#{schedule.start_day}-#{schedule.end_day} #{schedule.opening_hours}-#{schedule.closing_hours}</li>"
    end
    work_html
  end

end
