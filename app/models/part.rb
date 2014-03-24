class Part < ActiveRecord::Base
	scope :programs, -> { where("name LIKE 'PA%'").order("name asc") }

	has_many :rfqquotes, dependent: :destroy
end
