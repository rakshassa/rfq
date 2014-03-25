require 'spec_helper'
include ApplicationHelper

describe SearchesController do
	subject { page }

	describe "new" do
		let(:user) { User.create(name: "testTLX", isTLX: true) }
		before { visit new_search_path }
	
=begin
		it { should have_title(full_title('Find specific RFQs'))}
		it { should have_selector('h1', text: 'Advanced Search')}		


		describe "with vendor" do
			before do
				fill_in "Vendor", with: "testvendor"
				click_button "Search"
			end

			it { should have_title('RFQ Search Results')}
			it { should have_link('Advanced Search')}
		end
=end

	end
end
