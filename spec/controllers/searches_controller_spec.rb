require 'spec_helper'
include ApplicationHelper

describe SearchesController do
	subject { page }

	describe "new" do
		let(:user) { User.create(name: "testTLX", isTLX: true) }
		before { visit new_search_path }
	


	end
end
