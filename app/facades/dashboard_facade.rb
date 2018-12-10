class Admin
  class DashboardFacade

    def initialize; end

    def total_invest_amount(type)
      InvestmentData.send(type).joins(:amount_sources).sum(:'amount_sources.amount')
    end

    def total_loan_amount
      LoanData.joins(:amount_sources).sum(:'amount_sources.amount')
    end

  end
end
