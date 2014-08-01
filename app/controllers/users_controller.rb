class UsersController < ApplicationController

  def tlx
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
  	user = User.find_by(name: "testTLX")
    set_user(user)
    redirect_to root_path
  end

  def vendor
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
  	user = User.find_by(name: "testVendor1")
	  set_user(user)
	  redirect_to root_path
  end
end