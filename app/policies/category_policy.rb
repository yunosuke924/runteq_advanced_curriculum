class CategoryPolicy < TaxonomyPolicy
  def index?
    user.admin? || user.editor?
  end

  def show?
    true
  end

  def create?
    user.admin? || user.editor?
  end

  def edit?
    user.admin? || user.editor?
  end

  def update?
    user.admin? || user.editor?
  end

  def destroy?
    user.admin? || user.editor?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
