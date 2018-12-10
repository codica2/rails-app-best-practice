class Admin
  class DocumentsFacade
  
   attr_reader :loan, :investor

    def initialize(loan_id, investor_id)
      @loan = Loan.find(loan_id)
      @investor = Investor.find(investor_id) if investor_id.present?
    end

    def lender?
      @investor.present?
    end

    def new_document
      @loan.documents.build(investor_id: @investor.id)
    end

    def documents
      Document.where(investment_id: @loan.id, investor_id: @investor.id)
    end

    def lenders
      @loan.lenders.order(:name).uniq.collect { |l| [l.name, l.id] }
    end

    def placeholder
      lender? ? 'Please select lender' : 'Lenders'
    end

    def selected_lender
      @investor ? @investor.id : nil
    end

  end

end
