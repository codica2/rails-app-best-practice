class StorePolicy < ApplicationPolicy

  def show?
    record.operational?
  end

end
