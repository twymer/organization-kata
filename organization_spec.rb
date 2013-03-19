require_relative 'organization'
require_relative 'user'

describe Organization do
  before do
    @root_org = Organization.new
  end

  describe "root organization" do
    it "should default an added person to user" do
      user = User.new(1)
      @root_org.add_user(user)
      @root_org.user_permission(user).should == :user
    end

    it "should not give access to someone who wasn't added" do
      user = User.new(1)
      @root_org.user_permission(user).should == :disabled
    end

    it "should allow a user to be an admin" do
      user = User.new(1)
      @root_org.add_user(user, :admin)
      @root_org.user_permission(user).should == :admin
    end

    it "shouldn't allow bogus permissions" do
      user = User.new(1)
      @root_org.add_user(user, :banana)
      @root_org.user_permission(user).should == :disabled
    end
  end
end
