# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  comment    :text
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_reviews_on_user_id     (user_id)
#
class ReviewSerializer

  include JSONAPI::Serializer

  attributes :id, :comment, :rating, :created_at

  belongs_to :user

end
