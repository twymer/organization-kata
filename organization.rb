class Organization
  @@possible_permission_types = [:admin, :user, :disabled]

  def initialize(parent = nil)
    @users = {}
    @parent_org = parent
  end

  def possible_permission_types
    @@possible_permission_types
  end

  # Add user with a given permission value to this organization
  def add_user(user, permission = :user)
    if possible_permission_types.include? permission
      @users.merge!({ user.id => permission })
    end
  end

  # Check this organization for requested user. If not present here, attempt
  # to find an inherited permission value. The permission in the nearest
  # organization (recursing through parents) will be used. If user is not
  # found, return disabled
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
