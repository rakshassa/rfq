class Vendor < ActiveRecord::Base
	has_many :rfqquotes, dependent: :destroy
	has_many :vendor_contacts, dependent: :destroy
	has_many :vendor_addresses, dependent: :destroy

	def rfq_contact
		return self.vendor_contacts.role(APP_CONFIG['rfq_contact_role']).first
	end
end
