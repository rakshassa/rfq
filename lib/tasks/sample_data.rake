namespace :db do 
	desc "Fill database with sample data"
	task populate: :environment do
		make_employees
		make_vendors
		make_vendor_contacts
		make_parts
		make_users
		make_feedback

		
		make_rfqforms
		make_eaus
		make_rfqparts
	end
end

def make_employees
	20.times do |n|
		Employee.create(name: Faker::Name.name, email: Faker::Internet.email)
	end
end

def make_vendors
	20.times do |n|
		Vendor.create(name: Faker::Name.name, active_rfq: true)
	end
	5.times do |n|
		Vendor.create(name: Faker::Name.name, active_rfq: false)
	end	
end

def make_vendor_contacts
	Vendor.all.each do |v|
		c = v.vendor_contacts.build(name: Faker::Name.name, email: Faker::Internet.email)
		c.save
		v.rfq_contact_id = c.id
	end
end


def make_parts
	20.times do |n|
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

def make_feedback
	Feedback.create(name: "Too high")
	Feedback.create(name: "Design change")
	Feedback.create(name: "Other")
end


def make_rfqforms
	3.times do |n|
		Rfqform.create(
			date: DateTime.now.to_date,
			release_type: "Test",
			launch_date: "Yesterday",
			ppap: "Test ppap",
			req_by: 3,
			engineer: 2,
			built: false,
			info: "No info Here"
		)
	end
end

def make_eaus
	3.times do |n|
		5.times do |m|
			neweau = Rfqform.find(n+1).eaus.build(value: m)
			neweau.save
		end
	end
end

def make_rfqparts
	3.times do |n|
		1.times do |m|
			newpart = Rfqform.find(n+1).rfqparts.build(
				part_number: 1,
				revision: "First",
				qty: m,
				units: "pounds",
				rfqpartvendors: Array[1,2])
			newpart.save
		end
	end
end


