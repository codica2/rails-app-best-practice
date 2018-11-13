# == Schema Information
#
# Table name: listings
#
#  id                     :integer          not null, primary key
#  new                    :boolean
#  car_type               :integer
#  condition              :integer
#  place                  :string
#  gear_type              :integer
#  model_id               :integer
#  fuel_id                :integer
#  body_id                :integer
#  price                  :integer
#  mileage                :integer
#  certified              :boolean
#  description            :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  city_id                :integer
#  validated              :boolean          default(FALSE)
#  wheel                  :integer
#  climatisation          :boolean
#  slug                   :string
#  color_id               :integer
#  sold                   :boolean          default(FALSE), not null
#  year                   :integer
#  engine_capacity        :string
#  on_homepage_ended_at   :datetime
#  fixed_on_top_ended_at  :datetime
#  bumped_on_top_ended_at :datetime
#  position               :integer
#  last_reacted           :date
#  token                  :string
#  validated_at           :date
#  seller_type            :string
#  seller_id              :integer
#  type                   :string
#  spare_part_category_id :integer
#  impressions_count      :integer          default(0)
#

class VehicleListing < Listing

  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessor :brand_id

  # == Extensions ===========================================================

  friendly_id :url, use: %i[slugged finders]

  enum car_type: {
    car: 1,
    moto: 2,
    truck: 3
  }

  enum gear_type: {
    manual: 1,
    automatic: 2
  }

  enum wheel: {
    right: 1,
    left: 2
  }

  # == Relationships ========================================================
  belongs_to :model
  belongs_to :fuel
  belongs_to :color
  belongs_to :body_type, foreign_key: :body_id

  has_one :brand,  through: :model

  # == Validations ==========================================================
  validates :price, inclusion: { in: proc { Calculate::DefaultPriceRange.call } }
  validates :year,  inclusion: { in: 1900..Time.zone.today.year }, allow_blank: true

  validates :engine_capacity, :mileage, numericality: { greater_than: 0 }, allow_blank: true

  validates :mileage,     length: { maximum: 7    }
  validates :description, length: { maximum: 1000 }

  validates :car_type, :color_id, :gear_type, :fuel_id, :body_id, :model_id, presence: true

  # == Scopes ===============================================================
  scope :color,           ->(color_ids)       { where(color: color_ids) }
  scope :wheel,           ->(wheel_ids)       { where(wheel: wheel_ids) }
  scope :model_id,        ->(model_ids)       { where(model_id: model_ids) }
  scope :body_type,       ->(body_type_id)    { where(body_id: body_type_id) }
  scope :body_id,         ->(body_type_id)    { where(body_id: body_type_id) }
  scope :car_type,        ->(car_type_ids)    { where(car_type: car_type_ids) }
  scope :fuel_id,         ->(fuel_type_ids)   { where(fuel_id: fuel_type_ids) }
  scope :maxmileage,      ->(mileage)         { where("mileage <= ? OR mileage = '0' OR mileage IS NULL", mileage) }
  scope :minmileage,      ->(mileage)         { where("mileage >= ? OR mileage = '0' OR mileage IS NULL", mileage) }
  scope :gear_type,       ->(gear_type_ids)   { where(gear_type: gear_type_ids) }
  scope :type,            ->(car_type)        { where(car_type: VehicleListing.car_types[car_type]) }
  scope :make,            ->(name)            { joins(:model).where('models.name = ?', name) }
  scope :brand,           ->(name)            { joins(:brand).where('brands.name = ?', name) }
  scope :brand_id,        ->(brand_ids)       { joins(:brand).where(brands: { id: brand_ids }) }
  scope :body,            ->(name)            { joins(body_type: :translations).where('body_type_translations.name = ?', name) }

  # == Callbacks ============================================================
  has_secure_token :token

  # TODO: Remove :clear_unused_moto_fields after refactor create/edit ad forms
  before_save :clear_unused_moto_fields

  # == Class Methods ========================================================
  def self.prices
    validated.pluck(:price, :discount_price).map { |p| p.last || p.first }.compact
  end

  def self.max_price(currency)
    CalculateCurrency.call(price: prices.max, currency: currency)[:price]
  end

  def self.promoted_on_top(car_type, limit = ADS_ON_TOP)
    listings = validated.available.car_type(car_type)
    listings.on_promotion('fixed_on_top')
            .or(listings.on_promotion('on_homepage')).order('RANDOM()').limit(limit)
  end

  # == Instance Methods =====================================================
  # Slug generation rule

  def url
    I18n.t('common.ad_url', locale: I18n.default_locale, model_brand_name: brand&.name, model_name: model&.name,
                            city_region_name: region&.name, city_name: city&.name, id: id)
  end

  private

  def clear_unused_moto_fields
    return unless moto?

    self.climatisation = nil
    self.wheel = nil
  end

end
