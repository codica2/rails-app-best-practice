module LoanDataPerformer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

  end

  def end_date
    ([end_of_loan] + loan_date_extensions.pluck(:maturity_date_after_extension).compact).last
  end

  def nearest_end_date
    if loan_date_extensions.any?
      lde = loan_date_extensions.pluck(:maturity_date_after_extension).unshift(end_of_loan)
      lde.each { |date| return date if date > Date.today }
      lde[-1]
    else
      end_of_loan
    end
  end

  def dividends
    dividends = loan_dividends.select { |ld| ld.submited }.map(&:amount).inject { |sum, x| sum.to_f + x.to_f }
    dividends.round if dividends.present?
  end

end
