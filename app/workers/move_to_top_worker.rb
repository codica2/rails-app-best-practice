class MoveToTopWorker

  include Sidekiq::Worker
  sidekiq_options queue: ENV.fetch('CARRIERWAVE_BACKGROUNDER_QUEUE').to_sym

  def perform(prom_id, prom_class)
    promotion = prom_class.constantize.find(prom_id)
    return if promotion.bumped_on_top_ended_at < Time.zone.today

    promotion.bump_to_top
  end

end
