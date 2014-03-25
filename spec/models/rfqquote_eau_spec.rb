include SessionsHelper
require 'spec_helper'

describe RfqquoteEau do
	before do
		@rfqform = FactoryGirl.create(:rfqform_with_associations, rfqforms_count: 2)
		@eau = FactoryGirl.create(:eau, rfqform: @rfqform)		
		@vendor = FactoryGirl.create(:vendor)		
		@rfqpart = FactoryGirl.create(:rfqpart, rfqform: @rfqform)
		@rfqquote = FactoryGirl.create(:rfqquote, rfqform: @rfqform, rfqpart: @rfqpart, vendor: @vendor)
		@rfqquote_eau = FactoryGirl.create(:rfqquote_eau, rfqquote: @rfqquote, eau: @eau)
		@tlx_user = User.create(name: "testTLX", isTLX: true)
		@vendor_user = User.create(name: "testVendor1", isTLX: false, vendor_id: 1)		
	end

	subject { @rfqquote_eau }

	it { should respond_to(:rfqquote_id) }
	it { should respond_to(:eau_id) }
	it { should respond_to(:parts_note) }
	it { should respond_to(:unit_price) }
	it { should respond_to(:no_quote) }
	it { should respond_to(:tooling) }
	it { should respond_to(:nre) }
	it { should respond_to(:feedback) }

	it { should be_valid }

	describe "eau_qty" do
		before do
			@rfqpart.qty = 9
			@eau.value = 8
		end

		its(:eau_qty) { should eq(72) }
	end

	describe "when tooling" do
		describe "is a positive number" do
			before { @rfqquote_eau.tooling = 3.4567 }
			it { should be_valid }
		end
		describe "is a negative number" do
			before { @rfqquote_eau.tooling = -3.4567 }
			it { should_not be_valid }
		end
		describe "is not a number" do
			before { @rfqquote_eau.tooling = "bob" }
			it { should_not be_valid }
		end
	end

	describe "when nre" do
		describe "is a positive number" do
			before { @rfqquote_eau.nre = 3.4567 }
			it { should be_valid }
		end
		describe "is a negative number" do
			before { @rfqquote_eau.nre = -3.4567 }
			it { should_not be_valid }
		end
		describe "is not a number" do
			before { @rfqquote_eau.nre = "bob" }
			it { should_not be_valid }
		end
	end

	describe "when unit price" do
		describe "as tlx" do
			before { set_user(@tlx_user) }
			describe "is a positive number" do
				before { @rfqquote_eau.unit_price = 3.4567 }
				it { should be_valid }
			end
			describe "is a negative number" do
				before { @rfqquote_eau.unit_price = -3.4567 }
				it { should be_valid }
			end
			describe "is not a number" do
				before { @rfqquote_eau.unit_price = "bob" }
				it { should be_valid }
			end		
			describe "is no quote" do
				before { @rfqquote_eau.no_quote = true }	
				it { should be_valid }
			end
		end
		describe "as vendor" do
			before { set_user(@vendor_user) }
			describe "is a positive number" do
				before { @rfqquote_eau.unit_price = 3.4567 }
				it { should be_valid }
			end
			describe "is a negative number" do
				before { @rfqquote_eau.unit_price = -3.4567 }
				it { should_not be_valid }
			end
			describe "is not a number" do
				before { @rfqquote_eau.unit_price = "bob" }
				it { should_not be_valid }

				describe "is no quote" do
					before { @rfqquote_eau.no_quote = true }	
					it { should be_valid }
				end
			end
		end
	end

end

