
require 'spec_helper'

describe "StartSearches" do
	let (:user) { FactoryGirl.create(:tlx_user) }
	before do APP_CONFIG['default_user_name'] = user.name end

	it "opens search when clicking advanced search" do

		visit rfqforms_path
		click_link "Search"
		fill_in "Vendor", :with => "1"
		click_button "Search"

		current_path.should eq(search_path(Search.last.id))

		page.should have_content("All RFQ Forms")

		
	end


end
 