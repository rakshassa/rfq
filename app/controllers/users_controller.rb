class UsersController < ApplicationController

  def tlx
  	user = User.find_by(name: "testTLX")
    set_user(user)
    redirect_to root_path
  end

  def vendor
  	user = User.find_by(name: "testVendor1")
	set_user(user)
	redirect_to root_path
  end
end