class CartPolicy < ApplicationPolicy

  def show?
    user_active?
  end

  def create?
    user_active?
  end

  def update?
    user_active? && record.waiting_for_order_details?
  end

end
