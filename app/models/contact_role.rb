class ContactRole < ActiveRecord::Base

	has_many :vendor_contact_roles, dependent: :destroy

end
