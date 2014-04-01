include SessionsHelper
require 'spec_helper'

describe Rfqform do
	include_context 'created_rfqform'
	
	subject { rfqform }

	it { should respond_to(:date) }
	it { should respond_to(:due_date) }
	it { should respond_to(:release_type) }
	it { should respond_to(:launch_date) }
	it { should respond_to(:ppap) }
	it { should respond_to(:req_by) }
	it { should respond_to(:engineer) }
	it { should respond_to(:info) }
	it { should respond_to(:built) }
	it { should respond_to(:program) }

	it { should be_valid }

	describe "printable id" do
		before { rfqform.id = 16 }
		its(:printable_id) { should eq "0016"}
	end

	describe "program name" do
		let!(:newpart) do
			FactoryGirl.create(:part, name: "PA234")
		end
		before { rfqform.program = newpart.id }
		its(:program_name) { should eq "PA234" }
	end

	describe "create search" do
		let!(:newsearch_id) { newsearch_id = rfqform.create_search }

		its(:id) { should eq(Search.find(newsearch_id).rfq) }

		it "should create a search" do
			expect { rfqform.create_search }.to change(Search, :count).by(1)
		end
	end

	describe "auth quotes" do
		let!(:rfqquote) { FactoryGirl.create(:rfqquote, rfqform: rfqform, rfqpart: rfqpart, vendor: vendor) }
		let!(:rfqquote2) { FactoryGirl.create(:rfqquote, rfqform: rfqform, rfqpart: rfqpart, vendor: vendor2) }
			
		its(:rfqquotes) { should include(rfqquote, rfqquote2) }

		describe "as tlx" do
			before do set_user_name(tlx_user.name) end
			subject { rfqform.auth_quotes }
		
			its(:count) { should eq(2) }
		end
		describe "as vendor" do
			before do set_user_name( vendor_user.name) end
			subject { rfqform.auth_quotes }
		
			its(:count) { should eq(1) }
		end
	end

	describe "when req_by is missing" do
		before { rfqform.req_by = nil }
		it { should_not be_valid }
	end

	describe "when req_by is missing" do
		before { rfqform.engineer = nil }
		it { should_not be_valid }
	end

	describe "when req_by is missing" do
		before { rfqform.program = nil }
		it { should_not be_valid }
	end

	describe "rfqpart associations" do
		let!(:newpart) do
			FactoryGirl.create(:rfqpart, rfqform: rfqform)
		end

		its(:rfqparts) { should include(newpart) }
	end

	describe "eau associations" do
		let!(:neweau) do
			FactoryGirl.create(:eau, rfqform: rfqform)
		end

		its(:eaus) { should include(neweau) }
	end

	it "should destroy associations" do
		rfqparts = rfqform.rfqparts.to_a
		eaus = rfqform.eaus.to_a
		rfqform.destroy
		expect(rfqparts).not_to be_empty
		expect(eaus).not_to be_empty
		rfqparts.each do |part|
			expect(Rfqpart.where(id: part.id)).to be_empty
		end
		eaus.each do |eau|
			expect(Eau.where(id: eau.id)).to be_empty
		end
	end

end

