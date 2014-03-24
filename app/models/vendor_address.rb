class VendorAddress < ActiveRecord::Base
	
	scope :primary, -> { where(:primary => true).first }

	belongs_to :vendor

end
