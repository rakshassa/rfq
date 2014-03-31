namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do
		make_employees
		make_roles			
		make_vendors
		make_vendor_contacts
		make_parts
		make_users
		
		make_rfqforms
	end

	task base_data: :environment do
		if (Employee.count == 0) then make_employees end
		if (ContactRole.count == 0) then make_roles end
		if (Vendor.count == 0) then make_vendors end
		if (VendorContact.count == 0) then make_vendor_contacts end
		if (Part.count == 0) then make_parts end
		if (User.count == 0) then make_users end
	end

	task images: :environment do
		make_attachments
	end
end

def make_attachments
	p = Rfqpart.new

	p.rfqform_id = 1
	p.part_number = 1
	p.revision = "First"
	p.qty = 5
	p.units = "pounds"
	p.rfqpartvendors = Array[1,2]
	p.drawing = File.open(Rails.root.join('tmp','Form.png'))
	p.save
end


def make_employees
	10.times do |n|
		Employee.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, inactive: false)
	end
	10.times do |n|
		Employee.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, inactive: true)
	end
end

def make_roles
	ContactRole.create(name: "Contact 1")
	ContactRole.create(name: "Contact 2")
	ContactRole.create(name: "Contact 3")
	ContactRole.create(name: "RFQ Contact")
	ContactRole.create(name: "Other Contact")
	ContactRole.create(name: "Silly Contact")
end


def make_vendors
	20.times do |n|
		v = Vendor.create(name: Faker::Name.name, phone: Faker::PhoneNumber.phone_number, active_rfq: true)
		make_vendor_addresses(v)
	end
	5.times do |n|
		v = Vendor.create(name: Faker::Name.name, phone: Faker::PhoneNumber.phone_number, active_rfq: false)
		make_vendor_addresses(v)
	end	
end

def make_vendor_addresses(vendor)
	a = vendor.vendor_addresses.build(
                 address1: Faker::Address.street_address,
                 address2: Faker::Address.secondary_address,
                 city: Faker::Address.city,
                 state: Faker::Address.state_abbr,
                 zip: Faker::Address.zip_code,
                 address_type_id: 1,
                 primary: true)  
	a.save

	a = vendor.vendor_addresses.build(
                 address1: Faker::Address.street_address,
                 address2: Faker::Address.secondary_address,
                 city: Faker::Address.city,
                 state: Faker::Address.state_abbr,
                 zip: Faker::Address.zip_code,
                 address_type_id: 2,
                 primary: false)  
    a.save                    
end


def make_vendor_contacts
	roleId = ContactRole.where("name = ?", "RFQ Contact").first

	Vendor.all.each do |v|
		c = v.vendor_contacts.build(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email)
		c.save

		VendorContactRole.create(vendor_contact_id: c.id, contact_role_id: roleId.id)
	end

	VendorContactRole.create(vendor_contact_id: 1, contact_role_id: 1)
	VendorContactRole.create(vendor_contact_id: 2, contact_role_id: 2)
	VendorContactRole.create(vendor_contact_id: 1, contact_role_id: 5)
	VendorContactRole.create(vendor_contact_id: 2, contact_role_id: 5)
end


def make_parts
	5.times do |n|
		Part.create(name: "PA"+ n.to_s, description: Faker::Name.name)
	end
	30.times do |n|
		Part.create(name: Faker::Name.name, description: Faker::Name.name)
	end
	
end

def make_users

	User.create(name: "testTLX", isTLX: true)
	User.create(name: "testVendor1", isTLX: false, vendor_id: 1)
	
	3.times do |n|
		User.create(name: Faker::Name.name, isTLX: true)
	end

	3.times do |n|
		User.create(name: Faker::Name.name, isTLX: false, vendor_id: 1)
	end
end



def make_rfqforms
	
	30.times do |n|
		form = Rfqform.new(
			date: DateTime.now.to_date,
			due_date: (DateTime.now + 10.days).to_s,
			release_type: "Test",
			launch_date: "Yesterday",
			ppap: "Test ppap",
			req_by: 3,
			engineer: 2,
			built: false,
			program: 1,
			info: "No info Here"
		)
		form.rfqparts.build(
			:part_number => 1,
			:revision => "First",
			:qty => 5,
			:units => "pounds",
			:drawing => File.open(Rails.root.join('tmp','Form.png')),
			:rfqpartvendors => Array[1,2])
		form.eaus.build(:value => 1)
		form.eaus.build(:value => 2)
		form.save
	end
end



