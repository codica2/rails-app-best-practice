class DividendYear
  class YearlyDistributionPresenter < DividendYear::BaseDividendYearPresenter
    def dividends_year
      [value_decorator(@dividend_year.loan_dividends.sample.try(:amount))]
    end
  end
end
