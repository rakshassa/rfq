require 'spec_helper'

describe "NavigateForms" do
	let (:user) { FactoryGirl.create(:tlx_user) }
	before do APP_CONFIG['default_user_name'] = user.name end

	it "has no forms" do

		visit rfqforms_path

		page.should have_link("Search")
		page.should have_link("Home")
		page.should have_link("RFQ Forms")
		page.should have_link("Create")
		page.should have_content("All RFQ Forms")

		page.should_not have_link("View")
		page.should_not have_link("Print")
		page.should_not have_link("Build")
		page.should_not have_link("Delete")

		page.should_not have_content("rfqform_")
	end

	describe "with forms" do	

		let!(:part) { FactoryGirl.create(:part, :name => "PA01") }
		let!(:part2) { FactoryGirl.create(:part, :name => "PA02") }
		let!(:employee) { FactoryGirl.create(:employee, :first_name => "Bob", :last_name => "Smith") }
		
		let!(:vendor) { FactoryGirl.create(:vendor, :name => "First Vendor") }
		let!(:vcontact) { FactoryGirl.create(:vendor_contact, :vendor => vendor, :email => "some@abc.com") }
		let!(:vcontact_role) { FactoryGirl.create(:vendor_contact_role, :vendor_contact => vcontact) }

		let!(:vendor2) { FactoryGirl.create(:vendor) }
		let!(:vcontact2) { FactoryGirl.create(:vendor_contact, :vendor => vendor2, :email => "other@def.com") }
		let!(:vcontact_role2) { FactoryGirl.create(:vendor_contact_role, :vendor_contact => vcontact2) }

		let!(:rfqform) { FactoryGirl.create(:rfqform_with_eaus, 
			:program => part.id, :req_by => employee.id, :engineer => employee.id, ) }
		let!(:rfqpart) { FactoryGirl.create(:rfqpart,
			rfqform: rfqform, part_number: part.id, rfqpartvendors: [vendor,vendor2].map(&:id))}
		let!(:rfqpart2) { FactoryGirl.create(:rfqpart,
			rfqform: rfqform, part_number: part2.id, rfqpartvendors: [vendor,vendor2].map(&:id))}
		
		it "has the rfq" do	
			visit rfqforms_path

			page.should have_link("Search")
			page.should have_link("Home")
			page.should have_link("RFQ Forms")
			page.should have_link("Create")
			page.should have_content("All RFQ Forms")

			page.should have_link("View")
			page.should have_link("Print")
			page.should have_link("Build")
			page.should have_link("Delete")

			find('#rfqform_' + rfqform.id.to_s).should have_link("View")			
		end	
	

		describe "Create Quote" do
			before(:each) do
				visit rfqforms_path
				click_link "Create"			
			end

			it "navigates to create" do
				current_path.should eq(new_rfqform_path)

				page.should have_content("New RFQ Request")
				page.should have_link("Home")
				page.should have_link("RFQ Forms")	
				page.should have_button("Save")
				page.should have_link("Cancel")		
			end

			describe "cancel creation" do
				before do
					click_link("Cancel")
				end

				it "navigates on cancel" do
					current_path.should eq(rfqforms_path)
				end
			end

			describe "with default values" do
				before do
					click_button("Save")
				end

				it "fails to save" do				
					page.should have_content("errors")

					page.should have_content("New RFQ Request")
					page.should have_link("Home")
					page.should have_link("RFQ Forms")	
					page.should have_button("Save")
					page.should have_link("Cancel")					
				end
			end
		end

		describe "with values" do
			before do
				visit rfqforms_path
				click_link "Create"		

				page.fill_in 'rfqform[eaus_attributes][0][value]', :with => '5'
				page.select 'PA01', :from => 'Program'
				page.select 'Bob Smith', :from => 'rfqform[req_by]'
				page.select 'Bob Smith', :from => 'rfqform[engineer]'
				page.select 'PA02', :from => 'rfqform[rfqparts_attributes][0][part_number]'
				page.fill_in 'Revision', :with => 'first'
				page.fill_in 'rfqform[rfqparts_attributes][0][qty]', :with => '3'
				page.fill_in 'rfqform[rfqparts_attributes][0][units]', :with => 'feet'
				page.select "First Vendor", :from => 'rfqform_rfqparts_attributes_0_rfqpartvendors'
				page.attach_file 'rfqform_rfqparts_attributes_0_drawing', 'c:\temp\Form.png'

				click_button("Save")
			end

			it "saves" do
				page.should_not have_content("errors")

				puts "Forms: " + Rfqform.all.count.to_s

				current_path.should eq(rfqform_path(Rfqform.last.id))					
				page.should have_link("Home")
				page.should have_link("RFQ Forms")
				page.should have_content("RFQ Request")		

				page.should have_link("Build")					
				page.should have_link("Edit")
				page.should have_link("PDF")
			end		
		end

	end

end
