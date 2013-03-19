require 'pry'

class Organization
  @@possible_permission_types = [:admin, :user, :disabled]

  def initialize(parent = nil)
    @users = {}
    @parent_org = parent
  end

  def possible_permission_types
    @@possible_permission_types
  end

  def add_user(user, permission = :user)
    if possible_permission_types.include? permission
      @users.merge!({ user.id => permission })
    end
  end

  def user_permission(user)
    if @users.has_key? user.id
      @users[user.id]
    else
      if @parent_org
        @parent_org.user_permission(user)
      else
        :disabled
      end
    end
  end
end
