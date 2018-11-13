class DividendYear
  class QuarterlyDistributionPresenter < DividendYear::BaseDividendYearPresenter
    QUARTERS = %w[Q1 Q2 Q3 Q4].freeze

    def dividends_year
      QUARTERS.map do |quarter|
        value_decorator(select_dividend_by_quarter(@dividend_year, quarter).try(:amount))
      end
    end

    def select_dividend_by_quarter(dividend_year, quarter)
      dividend_year.loan_dividends.select(&:submited).find do|ld|
        quarter[1] == CalendarQuarter.from_date(ld.submitted_date).quarter.to_s
      end
    end

  end
end
