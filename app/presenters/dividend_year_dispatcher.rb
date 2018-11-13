class DividendYear
  class DividendYearDispatcher

    def initialize(dividend_year:, default_presenter: YearlyDistributionPresenter)
      @dividend_year = dividend_year
      @default_presenter = default_presenter
    end

    def results
      presenter.dividends_year
    end

    def presenter
      presenter_class(@dividend_year.distribution).new(@dividend_year)
    end

    def presenter_class(distribution)
      ('DividendYear::' + "#{distribution.gsub(/[ +]/,'_')}_distribution_presenter".camelize).safe_constantize || @default_presenter
    end
  end
end
