class Employee < ActiveRecord::Base
	scope :sorted, -> { order("first_name asc") }
	scope :active, -> { where(:inactive => false ) }

	has_many :rfqforms

	def name
		return self.first_name +  " " + self.last_name
	end
end
