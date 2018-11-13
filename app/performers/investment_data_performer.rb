module InvestmentDataPerformer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

  end

  def total_distribution
    investment.rental_properties? ? total_quarterly_distribution : total_distribution_dev
  end

  def profit_less_reserves_for_distribution
    return unless investment.profit_less_reserves_for_distribution

    investment.profit_less_reserves_for_distribution * holding / 100
  end

  def non_final_profit
    return nil unless investment.non_final_profit

    investment.non_final_profit * holding / 100
  end

  def final_distribution
    investment.distribution ? investment.distribution * holding / 100 : nil
  end

  def final_distribution_after_fee
    investment.distribution * holding / 100 * (100 - dragonfly_fee) / 100 if investment.distribution && dragonfly_fee
  end


  def last_distribution
    investment.distribution_years.try(:last).try(:distributions).try(:last).try(:amount)
  end

  def total_quarterly_distribution
    ((investment.total_distribution || 0) * holding / 100) || 0
  end

  def sale_distribution
    (distribution_from_sale || (investment.net_available_for_distribution || 0) * holding / 100) || 0
  end

end
