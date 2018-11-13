class ConnectListingsToSeller < BaseService

  attr_reader :resource, :listings_ids

  def initialize(resource, listings_ids)
    @resource = resource
    @listings_ids = listings_ids
  end

  def call
    return if !resource.persisted? || listings_ids.nil?
    connect_listings_to_seller
  end

  private

  def connect_listings_to_seller
    Listing.where(id: listings_ids).each { |listing| listing.update(seller: resource) if listing.seller.blank? }
  end

end
