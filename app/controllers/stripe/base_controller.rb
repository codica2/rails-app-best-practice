module Payments

  module Stripe

    class BaseController < ApplicationController

      def create
        customer = ::Stripe::Customer.create(
          email:  params[:stripeEmail],
          source: params[:stripeToken]
        )

        # min stipe payment in cents
        min_price = MIN_PAYMENT_VALUE * 100

        charge_price = price < min_price ? min_price : price

        charge = ::Stripe::Charge.create(
          customer:    customer.id,
          amount:      charge_price.to_i,
          description: Settings.site_name,
          currency:    'usd'
        )

        if charge['paid']
          payment_success(charge)
        else
          payment_error
        end
      rescue StandardError => e
        flash[:error] = e.message
        payment_error
      end

      private

      # == Overridden in each child
      def payment_success(price = 0)
        render json:
        {
          status: 200,
          url: payment_info_success_path(price: price)
        }
      end

      def payment_error
        render json:
        {
          status: 403,
          url: payment_info_error_path
        }
      end

      # == Overridden in each child
      # calculate price in cents
      def price
        0
      end

    end

  end

end
