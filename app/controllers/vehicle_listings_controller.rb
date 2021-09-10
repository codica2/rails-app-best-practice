module Dashboards

  class VehicleListingsController < BaseController

    layout 'dashboard'

    def index
      authorize! :manage, VehicleListing

      add_breadcrumb I18n.t('shared.footer.home'), :root_path
      add_breadcrumb I18n.t('ads.ad.my_profile'),  dashboard_path(locale: I18n.locale)

      @price_range = Calculate::PriceRange.call(VehicleListing.prices, @current_currency)
      @page        = Page::Listing::Vehicle::Search.new(listings: current_seller.vehicle_listings, params: params)

      current_seller.visit!(:my_vehicles)

      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def listings_params
      return {} if params[:listing].blank?

      params.require(:listing).permit(:city_id, :body_id, :model_id, :car_type, :brand_id, :start_date)
    end

  end

end
