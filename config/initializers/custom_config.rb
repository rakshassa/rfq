

#APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]

APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]


class String
	def to_bool
		return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
		return false if self == false || self =~ (/(false|f|no|n|0)$/i)
		raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
	end
end