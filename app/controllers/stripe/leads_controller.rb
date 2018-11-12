# frozen_string_literal: true

module Payments

  module Stripe

    class LeadsController < BaseController

      private

      def payment_params
        params.require(:lead).permit(:limit, :period, target: %i[city_id minprice maxprice body_id model_id car_type brand_id])
      end

      def leads
        leads = ::Lead.vehicle_listing.where.not(id: current_seller.leads.ids)
        ::Filter::Leads.call(leads: leads, params: payment_params, limit: payment_params[:limit].to_i)
      end

      def price
        price = ::Lead::PACK_PRICE[payment_params[:period].to_sym][:price]
        price * leads.count * 100
      end

      def payment_success(charge)
        AddLeadsToSeller.call(current_seller, leads)

        payment_price = charge['amount'].to_f / 100
        super(payment_price)
      end

    end

  end

end
