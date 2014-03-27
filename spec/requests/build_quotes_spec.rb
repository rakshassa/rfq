require 'spec_helper'

describe "BuildQuotes" do
	let (:user) { FactoryGirl.create(:tlx_user) }
	before do APP_CONFIG['default_user_name'] = user.name end

	describe "Build Quotes" do
	
		let!(:part) { FactoryGirl.create(:part, :name => "PA01") }
		let!(:part2) { FactoryGirl.create(:part, :name => "PA02") }
		let!(:employee) { FactoryGirl.create(:employee, :first_name => "Bob", :last_name => "Smith") }
		
		let!(:contact_role) { FactoryGirl.create(:contact_role, :name => "First") }
		let!(:contact_role1) { FactoryGirl.create(:contact_role, :name => "Second") }
		let!(:contact_role2) { FactoryGirl.create(:contact_role, :name => "Third") }
		let!(:contact_role3) { FactoryGirl.create(:contact_role, :name => "Fourth", :id => 4) }
		let!(:contact_role4) { FactoryGirl.create(:contact_role, :name => "Fifth") }
		let!(:rfq_role) { ContactRole.find(APP_CONFIG['rfq_contact_role'])}


		let!(:vendor) { FactoryGirl.create(:vendor, :name => "First Vendor") }
		let!(:vcontact) { FactoryGirl.create(:vendor_contact, :vendor => vendor, :email => "some@abc.com") }
		let!(:vcontact_role) { FactoryGirl.create(:vendor_contact_role, :contact_role => rfq_role, :vendor_contact => vcontact) }

		let!(:vendor2) { FactoryGirl.create(:vendor) }
		let!(:vcontact2) { FactoryGirl.create(:vendor_contact, :vendor => vendor2, :email => "other@def.com") }
		let!(:vcontact_role2) { FactoryGirl.create(:vendor_contact_role, :contact_role => rfq_role, :vendor_contact => vcontact2) }

		let!(:rfqform) { FactoryGirl.create(:rfqform_with_eaus, 
			:program => part.id, :req_by => employee.id, :engineer => employee.id, ) }
		let!(:rfqpart) { FactoryGirl.create(:rfqpart,
			rfqform: rfqform, part_number: part.id, rfqpartvendors: [vendor,vendor2].map(&:id))}
		let!(:rfqpart2) { FactoryGirl.create(:rfqpart,
			rfqform: rfqform, part_number: part2.id, rfqpartvendors: [vendor,vendor2].map(&:id))}


		it "creates quotes" do	

			puts "Parts: " + rfqform.rfqparts.count.to_s

			visit rfqforms_path
			click_link "Build"

			puts ActionMailer::Base.deliveries.inspect
			#last_email.to.should include(vcontact2.email)
			current_path.should eq(search_path(Search.last.id))			

			Rfqquote.all.count.should eq(4)
			rfqform.rfqparts.count.should eq(2)
			rfqform.rfqparts.first.rfqpartvendors.should include(vendor.id, vendor2.id)

			page.should have_link("Search")
			page.should have_link("Home")
			page.should have_link("RFQ Forms")
			page.should have_link("Create")
			page.should have_content("All RFQ Forms")

			page.should have_link("View")
			page.should have_link("Print")
			page.should_not have_link("Build")
			page.should_not have_link("Delete")

			find('#rfqform_' + rfqform.id.to_s).should have_link("View")
		end
	end
end
