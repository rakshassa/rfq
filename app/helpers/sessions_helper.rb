module SessionsHelper


  def set_user(user)
    APP_CONFIG['default_user_name'] = user.name
    @current_user = user
  end


  def current_user
    #remember_token = User.encrypt(cookies[:remember_token])
    #@current_user ||= User.find_by(remember_token: remember_token)

    #NOTE: this is a temporary solution until Tom delivers a mechanism to know the current user.
    #@current_user ||= User.find_by(name: "testVendor1")
    @current_user ||= User.find_by(name: APP_CONFIG['default_user_name'])      
  end  

  def current_user?(user)
    user == current_user
  end  

end
