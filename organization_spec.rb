require_relative 'organization'
require_relative 'user'

describe Organization do
  before do
    @user = User.new(1)
    @root_org = Organization.new
  end

  describe "root organization" do
    it "should default an added person to user" do
      @root_org.add_user(@user)
      @root_org.user_permission(@user).should == :user
    end

    it "should not give access to someone who wasn't added" do
      @root_org.user_permission(@user).should == :disabled
    end

    it "should allow a user to be an admin" do
      @root_org.add_user(@user, :admin)
      @root_org.user_permission(@user).should == :admin
    end

    it "shouldn't allow bogus permissions" do
      @root_org.add_user(@user, :banana)
      @root_org.user_permission(@user).should == :disabled
    end
  end

  describe "inheritence" do
    before do
      @sub_org = Organization.new(@root_org)
      @sibling_org = Organization.new(@root_org)
      @grandchild_org = Organization.new(@sub_org)
    end

    it "should inherit admin status from parent" do
      @root_org.add_user(@user, :admin)
      @sub_org.user_permission(@user).should == :admin
    end

    it "should not inherit a permission if one is already set" do
      @root_org.add_user(@user, :admin)
      @sub_org.add_user(@user, :user)
      @sub_org.user_permission(@user).should == :user
    end

    it "should not inherit from siblings" do
      @sub_org.add_user(@user, :admin)
      @sibling_org.user_permission(@user).should == :disabled
    end

    it "should inherit from nearest parent" do
      @root_org.add_user(@user, :user)
      @sub_org.add_user(@user, :admin)
      @grandchild_org.user_permission(@user).should == :admin
    end
  end
end
