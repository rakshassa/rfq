
require 'spec_helper'

describe "StartSearches" do
	let (:tlx_user) { FactoryGirl.create(:tlx_user) }
	before do set_user_name(tlx_user.name) end

	it "opens search when clicking advanced search" do

		visit rfqforms_path
		click_link "Search"
		fill_in "Vendor", :with => "1"
		click_button "Search"

		current_path.should eq(search_path(Search.last.id))

		page.should have_content("All RFQ Forms")		
	end

	describe "search by built" do
		before do
			visit rfqforms_path
			click_link "Search"
			page.select 'Built', :from => 'search[built]'
			click_button "Search"
		end

		it "opens search when clicking advanced search" do
			current_path.should eq(search_path(Search.last.id))

			page.should have_content("All RFQ Forms")			
		end	
	end
end
 