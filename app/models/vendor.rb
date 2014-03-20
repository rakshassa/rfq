class Vendor < ActiveRecord::Base
	has_many :rfqquotes, dependent: :destroy
	has_many :vendor_contacts, dependent: :destroy
end
