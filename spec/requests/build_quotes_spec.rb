require 'spec_helper'

describe "BuildQuotes" do
	let (:tlx_user) { FactoryGirl.create(:tlx_user) }
	before do 		
		APP_CONFIG['default_user_name'] = tlx_user.name 
	end

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
		let!(:vendor_address) { FactoryGirl.create(:vendor_address, :vendor => vendor)}
		let!(:vcontact) { FactoryGirl.create(:vendor_contact, :vendor => vendor, :email => "some@abc.com") }
		let!(:vcontact_role) { FactoryGirl.create(:vendor_contact_role, :contact_role => rfq_role, :vendor_contact => vcontact) }

		let!(:vendor2) { FactoryGirl.create(:vendor) }
		let!(:vendor_address2) { FactoryGirl.create(:vendor_address, :vendor => vendor2)}
		let!(:vcontact2) { FactoryGirl.create(:vendor_contact, :vendor => vendor2, :email => "other@def.com") }
		let!(:vcontact_role2) { FactoryGirl.create(:vendor_contact_role, :contact_role => rfq_role, :vendor_contact => vcontact2) }

		let!(:rfqform) { FactoryGirl.create(:rfqform_with_eaus, 
			:program => part.id, :req_by => employee.id, :engineer => employee.id, :eaus_count => 3 ) }
		let!(:rfqpart) { FactoryGirl.create(:rfqpart,
			rfqform: rfqform, part_number: part.id, rfqpartvendors: [vendor,vendor2].map(&:id))}
		let!(:rfqpart2) { FactoryGirl.create(:rfqpart,
			rfqform: rfqform, part_number: part2.id, rfqpartvendors: [vendor,vendor2].map(&:id))}

		let (:vendor_user) { FactoryGirl.create(:vendor_user, :vendor_id => vendor.id) }


		describe "send feedback" do
			
			it "should send feedback", js: true do			
			
				visit rfqforms_path
				reset_email
				click_link "Build"
				alert = page.driver.browser.switch_to.alert
				alert.accept

				APP_CONFIG['default_user_name'] = tlx_user.name
				click_link "-001"

			
				current_path.should eq(rfqquote_path(Rfqquote.first.id))

				click_link "Edit"

				page.fill_in 'rfqquote[rfqquote_eaus_attributes][0][feedback]', :with => 'too low'
				page.fill_in 'rfqquote[rfqquote_eaus_attributes][1][feedback]', :with => 'too high'
				page.fill_in 'rfqquote[rfqquote_eaus_attributes][2][feedback]', :with => 'too Little'
				click_button "Save"			
			
				click_link "Feedback"

				alert = page.driver.browser.switch_to.alert
				alert.accept

				current_path.should eq(rfqforms_path)

				last_email.to.should include(vcontact.email)

				click_link "-001"
				current_path.should eq(rfqquote_path(Rfqquote.first.id))

				Rfqquote.first.feedback_sent.should be_true
				Rfqquote.first.date_feedback_sent.should eq(DateTime.now.to_date)

				page.should have_content("Request For Quote")
				page.should have_link("Drawing")
				page.should_not have_link("Edit")
				page.should_not have_link("Feedback")
				page.should have_link("PDF")				
				
			end
						
		end

		describe "good build" do
			before do
				visit rfqforms_path
				
				page.should have_xpath("//ul//div//div[contains(@id,'rfqform_')]", :count => 1)
				reset_email
				click_link "Build"
			end

			it "creates quotes" do					
				last_email.bcc.should include(vcontact2.email, vcontact.email)

				current_path.should eq(search_path(Search.last.id))	

				page.should have_xpath("//ul//div//div[contains(@id,'rfqform_')]", :count => 1)		
				page.should have_xpath("//td//a[contains(@href,'rfqquotes')]", :count => 4)	

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

				page.should have_link("-001")
				page.should have_link("-002")

				find('#rfqform_' + rfqform.id.to_s).should have_link("View")
			end

			describe "view quote" do
				let!(:quote) { Rfqquote.first }
				before do
					
					APP_CONFIG['default_user_name'] = tlx_user.name
					click_link "-001"
				end
				it "should view quote" do
					current_path.should eq(rfqquote_path(quote.id))

					page.should have_content("Request For Quote")
					page.should have_link("Drawing")
					page.should have_link("Edit")
					page.should have_link("Feedback")
					page.should have_link("PDF")

					page.should_not have_content("A. All info")
				end

				describe "fail feedback" do
					before do
						quote.feedback_sent = true
						quote.save						
					end	

					it "should not allow edit" do
						click_link "Edit"

						current_path.should eq(rfqforms_path)
						page.should_not have_link("Cancel")						
						page.should have_css('div.alert-error')
						page.should have_content("quote is closed")
					end

					it "should not allow edit" do
						click_link "Feedback"

						page.should_not have_link("Cancel")
						page.should have_link("PDF")
						page.should have_css('div.alert-error')
						page.should have_content("already sent")
					end					
				end			

				describe "edit feedback" do
					before do
						click_link "Edit"
					end

					it "should edit" do
						current_path.should eq(edit_rfqquote_path(quote.id))

						page.should have_content("Request For Quote")

						page.should have_xpath("//td//input[contains(@name,'[feedback]')]", :count => rfqform.eaus.count)

						page.should have_link("Drawing")
						page.should have_button("Save")
						page.should have_link("Cancel")
					end

					describe "save" do
						before do
							page.fill_in 'rfqquote[rfqquote_eaus_attributes][0][feedback]', :with => 'too low'														
						end

						it "should not allow feedback" do
							click_button "Save"

							page.should_not have_link("Cancel")
							page.should have_link("PDF")
							click_link "Feedback"

							page.should have_link("PDF")
							page.should have_content("Request For Quote")
							page.should have_css('div.alert-error')
							page.should have_content("enter feedback for all quotes before sending")
						end


						it "should save" do
							page.fill_in 'rfqquote[rfqquote_eaus_attributes][1][feedback]', :with => 'too high'
							click_button "Save"

							current_path.should eq(rfqquote_path(quote.id))

							page.should_not have_xpath("//td//input[contains(@name,'[feedback]')]")

							page.should have_content("too low")
							page.should have_content("too high")
						end
					end
				end
			end
		end

		describe "rebuild" do
			let!(:last_form) { Rfqform.last }

			before do
				visit rfqforms_path
				last_form.built = true
				last_form.save
			end
			it "doesnt rebuild" do
				page.should have_xpath("//ul//div//div[contains(@id,'rfqform_')]", :count => 1)
			
				click_link "Build"

				current_path.should eq(rfqforms_path)
				page.should have_css('div.alert-error')
				page.should have_content("already been built")
				page.should have_xpath("//ul//div//div[contains(@id,'rfqform_')]", :count => 1)
				page.should_not have_xpath("//td//a[contains(@href,'rfqquotes')]")	
			end
		end

	end
end
