# == Schema Information
#
# Table name: loans
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  car_type        :integer
#  amount_of_money :string
#  monthly_income  :string
#  currency        :string
#  city_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Loan < ApplicationRecord

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Extensions ===========================================================
  enum car_type: %i[new_car second_hand import]

  # == Relationships ========================================================
  belongs_to :city
  has_one :phone_number, as: :phoneable, dependent: :destroy, inverse_of: :phoneable

  accepts_nested_attributes_for :phone_number

  # == Validations ==========================================================
  validates :name, :car_type, :currency, :city_id, presence: true
  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :amount_of_money, :monthly_income, presence: true,
                                               numericality: { only_integer: true, greater_than: 0 },
                                               length: { maximum: 10 }

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

end
