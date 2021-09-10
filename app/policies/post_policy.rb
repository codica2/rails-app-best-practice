class PostPolicy < ApplicationPolicy

  def create?
    user_active?
  end

  def destroy?
    user_active? && current_user.posts.include?(record)
  end

  def like?
    user_active? && Like.find_by(post: record, user: current_user).blank?
  end

end
