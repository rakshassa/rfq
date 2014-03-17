class Vendor < ActiveRecord::Base

	has_many :vendor_contacts, dependent: :destroy
end
