FactoryGirl.define do 

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
		rfqpartvendors Array[1,2]
		drawing File.open(Rails.root.join('tmp','Form.png'))
	end

	factory :eau do
		rfqform
		value 3
	end

	factory :rfqform do
		date DateTime.now.to_date
		release_type "release type 1"
		launch_date DateTime.now.to_date
		ppap "PPAP1"
		req_by 1
		engineer 1
		info "No Info"		
		program 1

		factory :built do
			built true
		end

		factory :rfqform_with_associations do
			ignore do
				rfqforms_count 5
				eaus_count 3
			end
			after(:create) do |rfqform, evaluator|
				create_list(:rfqpart, evaluator.rfqforms_count, rfqform: rfqform)
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
		tooling 3.21
		nre 1.23
		feedback "None"
	end

end

