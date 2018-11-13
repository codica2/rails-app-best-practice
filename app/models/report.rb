# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  subject    :integer          not null
#  comment    :string
#  listing_id :integer
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ApplicationRecord

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Extensions ===========================================================
  enum subject: %i[sold scam wrong_number]

  # == Relationships ========================================================
  belongs_to :listing

  # == Validations ==========================================================
  validates :subject, presence: true

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

end
