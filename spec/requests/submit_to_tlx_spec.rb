require 'spec_helper'

describe "Vendor User" do

	include_context 'created_rfqform'

	let!(:quotes) { rfqform.build() }
	let!(:quote) { quotes.first }

	before do
		set_user_name(vendor_user.name)
		visit rfqforms_path
	end	

	it "limits quotes to vendor" do					
		quotes.count.should eq(4)

		page.should have_xpath("//ul//div//div[contains(@id,'rfqform_')]", :count => 1)		
		page.should have_xpath("//td//a[contains(@href,'rfqquotes')]", :count => 2)	

		
		page.should_not have_link("Search")
		page.should have_link("Home")
		page.should have_link("RFQ Forms")
		page.should_not have_link("Create")
		page.should have_content("All RFQ Forms")

		page.should_not have_link("View")
		page.should_not have_link("Print")
		page.should_not have_link("Build")
		page.should_not have_link("Delete")

		page.should have_link("-001")
		page.should_not have_link("-002")
		page.should have_link("-003")
		page.should_not have_link("-004")

		find('#rfqform_' + rfqform.id.to_s).should_not have_link("View")
	end	

	describe "View Quote" do
		before do
			click_link "-001"
		end

		it "shows vendor view" do
			current_path.should eq(rfqquote_path(quote.id))

			page.should have_content("Request For Quote")
			page.should have_link("Drawing")
			page.should have_link("Edit")
			page.should_not have_link("Feedback")
			page.should_not have_link("Submit")
			page.should have_link("PDF")

			page.should have_content("A. All info")
		end

		describe "Edit Quote" do
			before do
				click_link "Edit"
			end

			it "edits" do
				current_path.should eq(edit_rfqquote_path(quote.id))

				page.should have_content("Request For Quote")

				page.should_not have_xpath("//td//input[contains(@name,'[feedback]')]")
				page.should have_xpath("//td//input[contains(@name,'[parts_note]')]", :count => rfqform.eaus.count)

				page.should have_link("Drawing")
				page.should have_button("Save")
				page.should have_link("Cancel")
			end

			describe "save" do
				before do
					page.fill_in 'rfqquote[rfqquote_eaus_attributes][0][parts_note]', :with => 'junk'
					page.fill_in 'rfqquote[rfqquote_eaus_attributes][0][unit_price]', :with => '5'

					check 'rfqquote[rfqquote_eaus_attributes][1][no_quote]'
					

					page.fill_in 'rfqquote[quote_number]', :with => '12'
					
					page.select 'Jan', :from => 'rfqquote[quote_date(2i)]'
					page.select '1', :from => 'rfqquote[quote_date(3i)]'
					page.select '2019', :from => 'rfqquote[quote_date(1i)]'

					page.fill_in 'rfqquote[submitted_by]', :with => 'me'

					page.select 'Jan', :from => 'rfqquote[valid_till(2i)]'
					page.select '1', :from => 'rfqquote[valid_till(3i)]'
					page.select '2019', :from => 'rfqquote[valid_till(1i)]'					
				end

				it "fails save with insufficient fields" do
					click_button "Save"
					page.should have_css('div.alert-error')
					page.should_not have_link("PDF")
					page.should have_link("Cancel")
				end

				it "fails save when already submitted" do
					quote.submitted_to_tlx = true
					quote.save(:validate => false)					

					check 'rfqquote[rfqquote_eaus_attributes][2][no_quote]'
					click_button "Save"

					current_path.should eq(rfqforms_path)

					page.should have_css('div.alert-error')
					page.should have_content("already been submitted")
				end

				describe "save successful" do
					before do
						check 'rfqquote[rfqquote_eaus_attributes][2][no_quote]'
						click_button "Save"
					end

					it "saves successfully" do
						quote.submitted_by = "me"
						quote.quote_number = "12"

						current_path.should eq(rfqquote_path(quote.id))
						page.should_not have_css('div.alert-error')

						page.should have_link("Submit")
						page.should have_link("PDF")

						page.should have_content("A. All info")
					end

					describe "insufficient data" do
						before do
							quote.update_attribute(:quote_number, "")

							click_link "Submit"
						end

						it "fails to submit" do
							page.should have_css('div.alert-error')
							page.should have_content("enter quote")							
						end
					end

					describe "already submitted" do
						before do
							quote.submitted_to_tlx = true
							quote.save(:validate => false)					

							click_link "Submit"
						end

						it "fails" do
							page.should have_css('div.alert-error')
							page.should have_content("previously submitted")							
						end
					end

					describe "submit" do
						before do
							click_link "Submit"
						end

						it "submits successfully" do
							current_path.should eq(rfqforms_path)

							last_email.to.should include(APP_CONFIG['default_email_from'])
						end

						describe "view submitted" do
							before do
								click_link "-001"
							end

							it "should restrict actions" do
								current_path.should eq(rfqquote_path(quote.id))

								page.should_not have_css('div.alert-error')

								page.should have_content("Request For Quote")
								page.should have_link("Drawing")
								page.should_not have_link("Edit")
								page.should_not have_link("Feedback")
								page.should_not have_link("Submit")
								page.should have_link("PDF")

								page.should have_content("A. All info")	
							end
						end						
					end
				end
			end					
		end
	end
end