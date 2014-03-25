include SessionsHelper
require 'spec_helper'

describe Rfqquote do
	before do
		@rfqform = FactoryGirl.create(:rfqform_with_associations, rfqforms_count: 2)
		@tlx_user = User.create(name: "testTLX", isTLX: true)
		@vendor_user = User.create(name: "testVendor1", isTLX: false, vendor_id: 1)
		@vendor = FactoryGirl.create(:vendor)
		@vendor2 = FactoryGirl.create(:vendor)
		@rfqpart = FactoryGirl.create(:rfqpart, rfqform: @rfqform)
		@rfqquote = FactoryGirl.create(:rfqquote, rfqform: @rfqform, rfqpart: @rfqpart, vendor: @vendor)
		@rfqquote2 = FactoryGirl.create(:rfqquote, rfqform: @rfqform, rfqpart: @rfqpart, vendor: @vendor2)
	end

	subject { @rfqquote }

	it { should respond_to(:rfqform_id) }
	it { should respond_to(:vendor_id) }
	it { should respond_to(:part_id) }
	it { should respond_to(:rfqquote_display_id) }
	it { should respond_to(:quote_note) }
	it { should respond_to(:quote_number) }
	it { should respond_to(:quote_date) }
	it { should respond_to(:submitted_by) }
	it { should respond_to(:exceptions) }
	it { should respond_to(:submitted_to_tlx) }
	it { should respond_to(:date_submitted) }
	it { should respond_to(:feedback_sent) }
	it { should respond_to(:date_feedback_sent) }
	it { should respond_to(:rfqform) }
	it { should respond_to(:vendor) }
	it { should respond_to(:rfqpart) }
	it { should respond_to(:rfqquote_eaus) }
    

	it { should be_valid }

	describe "as tlx" do
		before do set_user(@tlx_user) end

		its(:valid_user) { should be_false }
	end
	describe "as vendor" do
		before do set_user(@vendor_user) end

		its(:valid_user) { should be_true }
	end

	describe "printable id" do
		before { @rfqquote.rfqquote_display_id = 16 }
		its(:printable_id) { should eq "016"}
		its(:whole_printable_id) { should eq(@rfqform.printable_id + "-016") }
	end


	describe "when quote number is missing" do
		before { @rfqquote.quote_number = nil }

		describe "as tlx" do
			before { set_user(@tlx_user) }
			it { should be_valid }
		end
		describe "as vendor" do
			before { set_user(@vendor_user) }
			it { should_not be_valid }
		end		
	end

	describe "when quote_date is missing" do
		before { @rfqquote.quote_date = nil }
		describe "as tlx" do
			before { set_user(@tlx_user) }
			it { should be_valid }
		end
		describe "as vendor" do
			before { set_user(@vendor_user) }
			it { should_not be_valid }
		end		
	end

	describe "when submitted_by is missing" do
		before { @rfqquote.submitted_by = nil }
		describe "as tlx" do
			before { set_user(@tlx_user) }
			it { should be_valid }
		end
		describe "as vendor" do
			before { set_user(@vendor_user) }
			it { should_not be_valid }
		end	
	end

	describe "when valid_till is missing" do
		before { @rfqquote.valid_till = nil }
		describe "as tlx" do
			before { set_user(@tlx_user) }
			it { should be_valid }
		end
		describe "as vendor" do
			before { set_user(@vendor_user) }
			it { should_not be_valid }
		end	
	end	

end

