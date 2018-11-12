module Dashboards

  class LeadsController < BaseController

    layout 'dashboard', except: %i[index]
    before_action :set_price_range, except: :update
    PER_PAGE = 20

    before_action except: :update do
      add_breadcrumb I18n.t('shared.footer.home'), :root_path
    end

    def index
      authorize! :read, Lead
      add_breadcrumb I18n.t('dashboard.leads.my_leads')
      f_params = filtering_params.presence || { status: :pending }
      @leads = Filter::Leads.call(leads: current_seller.leads.listing,
                                  params: f_params)
                            .paginate(page: params[:page], per_page: PER_PAGE).order(created_at: :desc)
      current_seller.visit!(:my_leads)
      respond_to do |format|
        format.html
        format.js
      end
    end

    def new
      authorize! :read, Lead
      add_breadcrumb I18n.t('dashboard.menu.buy_more_leads')
      @page = Page::Dashboard::Lead::Buy.new(current_seller, filtering_params)
      respond_to do |format|
        format.html
        format.js
      end
    end

    def update
      leads = current_seller.seller_leads
      seller_lead = leads.find_by(lead_id: params[:id])
      seller_lead.update(status: filtering_params[:status])
    end

    private

    def set_price_range
      @price_range = Calculate::PriceRange.call(VehicleListing.prices, @current_currency)
    end

    def filtering_params
      return {} if params[:lead].blank?
      params.require(:lead).permit(:ids, :period, :status, :start_date, :end_date, :listing, :status,
                                   target: %i[city_id minprice maxprice body_id model_id car_type brand_id])
    end

  end

end
