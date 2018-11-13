class DividendYear
  class MonthlyDistributionPresenter < DividendYear::BaseDividendYearPresenter
    MONTHS   = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

    def dividends_year
      MONTHS.map do |month|
        value_decorator(select_dividend_by_month(@dividend_year, month).try(:amount))
      end
    end

    def select_dividend_by_month(dividend_year, month)
      dividend_year.loan_dividends.select(&:submited).find { |ld| ld.submitted_date.strftime('%b') == month }
    end
  end
end
