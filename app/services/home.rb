module Page

  class Home

    ADS_LIMIT = 24
    SPARE_PART_LIMIT = 9
    OG_ADS_LIMIT = 5
    POSTS_LIMIT = 8
    POPULAR_BRANDS_LIMIT = 8

    attr_reader :currency

    def initialize(currency = 'USD')
      @currency = currency
    end

    def latest_ads
      ads_on_promotion = VehicleListing.validated.with_pictures.on_promotion('on_homepage').distinct
      return ads_on_promotion.sample(ADS_LIMIT) if ads_on_promotion.count >= ADS_LIMIT

      (ads_on_promotion + VehicleListing.validated.with_pictures.order('created_at desc').distinct).uniq.first(ADS_LIMIT)
    end

    def latest_spare_parts
      ads_on_promotion = SparePartListing.validated.with_pictures.on_promotion('on_homepage').distinct
      return ads_on_promotion.sample(ADS_LIMIT) if ads_on_promotion.count >= SPARE_PART_LIMIT

      (ads_on_promotion + SparePartListing.validated.with_pictures.order('created_at desc').distinct).uniq.first(SPARE_PART_LIMIT)
    end

    def price_range
      ::Calculate::PriceRange.call(VehicleListing.prices, currency)
    end

    def car_types
      ::Model.car_types
    end

    def posts
      ::Post.first(POSTS_LIMIT)
    end

    def general_message
      ::GeneralMessage.main_page_message.active.first
    end

    def popular_car_brands
      ::Brand.with_icon.car.popular.first(POPULAR_BRANDS_LIMIT)
    end

    def popular_moto_brands
      ::Brand.with_icon.moto.popular.first(POPULAR_BRANDS_LIMIT)
    end

    def popular_truck_brands
      ::Brand.with_icon.truck.popular.first(POPULAR_BRANDS_LIMIT)
    end

    def og_data
      return if latest_ads.blank?

      ad = latest_ads.first(OG_ADS_LIMIT).sample
      { custom_image: ad.primary_picture }
    end

  end

end
