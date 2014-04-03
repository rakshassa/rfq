FactoryGirl.define do 


	factory :user do

		factory :tlx_user do
			name "testTLX"			
			isTLX true
		end

		factory :vendor_user do
			name "testVendor1"
			vendor_id 1
			isTLX false
		end
	end

	factory :part do
		name "PA12"
		description "Part Assembly 12"
	end

	factory :rfqpart do
		
		rfqform
		part_number 1
		revision "rev 1"
		qty 5
		units "feet"
		drawing File.open(Rails.root.join('tmp','Form.png'))
		rfqpartvendors Array[1,2]
		
	end

	factory :eau do
		rfqform
		value 3
	end

	factory :rfqform do
		date DateTime.now.to_date
		due_date (DateTime.now + 10.days).to_date
		release_type "release type 1"
		launch_date DateTime.now.to_date
		ppap "PPAP1"
		req_by 1
		engineer 1
		info "No Info"		
		program 1
		built false

		factory :rfqform_with_eaus do
			ignore do
				#rfqparts_count 5
				eaus_count 3
			end
			after(:create) do |rfqform, evaluator|
				#create_list(:rfqpart, evaluator.rfqparts_count, rfqform: rfqform, part_number: rfqform.program)
				create_list(:eau, evaluator.eaus_count, rfqform: rfqform)
			end
		end
	end

	factory :rfqquote do
		rfqform
		vendor
		rfqpart

		rfqquote_display_id 1
		quote_note "Note here"
		quote_number "Number here"
		quote_date DateTime.now.to_date
		submitted_by "sub by me"
		valid_till DateTime.now.to_date
		exceptions false
		submitted_to_tlx false
		date_submitted DateTime.now.to_date
		feedback_sent false
		date_feedback_sent DateTime.now.to_date
	end

	factory :employee do
		first_name "test"
    	last_name "tester"
    	email "test@test.com"
    	inactive false
    end

	factory :vendor_contact_role do
		vendor_contact
		contact_role 
	end

	factory :vendor_contact do
		vendor
	    first_name "Firsty"
		last_name "Lasty"
		email "test_email@test.com"
	end	

	factory :vendor do
		name "Vendor1"
		active_rfq true
		phone "555-555-9777"
	end	

	factory :rfqquote_eau do
		rfqquote
		eau

		parts_note "part note"
		unit_price 5.45
		no_quote false
		tooling 3
		nre 1
		feedback "None"
	end

	factory :contact_role do
		name "First Contact"
	end

	factory :vendor_address do
    	vendor 
    	address1 "3111 test rd"
    	address2 "apt 32"
    	city "Milwaukee"
    	state "WI"
    	zip "53005"
    	address_type_id 1
      	primary	true	
    end

end

