include SessionsHelper
require 'spec_helper'

describe RfqquoteEau do
	include_context 'created_rfqform'

	let!(:quotes) { rfqform.build() }
	let!(:rfqquote_eau) { quotes[1].rfqquote_eaus.first }		

	subject { rfqquote_eau }

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
			rfqpart.qty = 9
			rfqpart.save
			rfqform.eaus.first.value = 8
			rfqform.eaus.first.save
		end

		its(:eau_qty) { should eq(72) }
	end

	describe "when tooling" do
		describe "is a decimal number" do
			before { rfqquote_eau.tooling = 3.4567 }
			it { should_not be_valid }
		end
		describe "is a positive number" do
			before { rfqquote_eau.tooling = 3 }
			it { should be_valid }
		end
		describe "is a negative number" do
			before { rfqquote_eau.tooling = -3.4567 }
			it { should_not be_valid }
		end
		describe "is not a number" do
			before { rfqquote_eau.tooling = "bob" }
			it { should_not be_valid }
		end
	end

	describe "when nre" do
		describe "is a decimal number" do
			before { rfqquote_eau.nre = 3.4567 }
			it { should_not be_valid }
		end
		describe "is a positive number" do
			before { rfqquote_eau.nre = 3 }
			it { should be_valid }
		end
		describe "is a negative number" do
			before { rfqquote_eau.nre = -3.4567 }
			it { should_not be_valid }
		end
		describe "is not a number" do
			before { rfqquote_eau.nre = "bob" }
			it { should_not be_valid }
		end
	end

	describe "when unit price" do
		describe "as tlx" do
			before { set_user(tlx_user) }
			describe "is a positive number" do
				before { rfqquote_eau.unit_price = 3 }
				it { should be_valid }
			end
			describe "is a decimal number" do
				before { rfqquote_eau.unit_price = 3.23 }
				it { should be_valid }
			end
			describe "is a negative number" do
				before { rfqquote_eau.unit_price = -3.4567 }
				it { should be_valid }
			end
			describe "is not a number" do
				before { rfqquote_eau.unit_price = "bob" }
				it { should be_valid }
			end		
			describe "is no quote" do
				before { rfqquote_eau.no_quote = true }	
				it { should be_valid }
			end
		end
		describe "as vendor" do
			before { set_user(vendor_user) }
			describe "is a positive number" do
				before { rfqquote_eau.unit_price = 3 }
				it { should be_valid }
			end
			describe "is a decimal number" do
				before { rfqquote_eau.unit_price = 3.23 }
				it { should be_valid }
			end
			describe "is a negative number" do
				before { rfqquote_eau.unit_price = -3 }
				it { should_not be_valid }
			end
			describe "is not a number" do
				before { rfqquote_eau.unit_price = "bob" }
				it { should_not be_valid }

				describe "is no quote" do
					before { rfqquote_eau.no_quote = true }	
					it { should be_valid }
				end
			end
		end
	end
end

