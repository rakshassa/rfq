module UserMacros
	def set_user_name(name)
		APP_CONFIG['default_user_name'] = name
	end

end
