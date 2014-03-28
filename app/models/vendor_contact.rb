class VendorContact < ActiveRecord::Base

	scope :limit_to_vendor, ->(vendor_id_param) { where(:vendor_id => vendor_id_param) }

	scope :role, ->(role) { 
		joins(:vendor_contact_roles).
		where('vendor_contact_roles.contact_role_id = ?', role ) }

	belongs_to :vendor

	has_many :vendor_contact_roles

	def name
		return self.first_name + " " + self.last_name
	end

end
