class CheckAdWorker

  include Sidekiq::Worker
  sidekiq_options queue: ENV['CARRIERWAVE_BACKGROUNDER_QUEUE'].to_sym

  def perform(ad_id)
    @ad = Listing.find(ad_id)
    return if @ad.blank?
    mark_as_sold if not_reacted?
    return if @ad.sold?
    send_email
    CheckAdWorker.perform_in(DAYS_TO_CHECK_AD.days, @ad.id)
  end

  private

  def mark_as_sold
    @ad.update_attribute('sold', true) # rubocop:disable SkipsModelValidations
  end

  def not_reacted?
    @ad.last_reacted < Time.zone.today - DAYS_TO_MARK_AS_SOLD
  end

  def send_email
    CheckAdMailer.check_email(@ad).deliver_now
  end

end
