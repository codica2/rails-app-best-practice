class PartnerDeactivateWorker

  include Sidekiq::Worker
  sidekiq_options queue: ENV['CARRIERWAVE_BACKGROUNDER_QUEUE'].to_sym

  def perform(id)
    @partner = Partner.find(id)
    deactivate_partner if @partner.active_to < Time.zone.today
  end

  private

  def deactivate_partner
    @partner.update(active: false, active_to: nil)
  end

end
