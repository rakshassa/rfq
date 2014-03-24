class VendorContactRole < ActiveRecord::Base

	scope :rfq_contacts, ->(contact_role) { where(:contact_role_id => contact_role) }

	belongs_to :vendor_contact
	belongs_to :contact_role
end
