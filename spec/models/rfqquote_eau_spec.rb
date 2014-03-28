include SessionsHelper
require 'spec_helper'

describe RfqquoteEau do
	let (:tlx_user) { FactoryGirl.create(:tlx_user) }

	before do APP_CONFIG['default_user_name'] = tlx_user.name end

	let!(:part) { FactoryGirl.create(:part, :name => "PA01") }
	let!(:part2) { FactoryGirl.create(:part, :name => "PA02") }
	let!(:employee) { FactoryGirl.create(:employee, :first_name => "Bob", :last_name => "Smith") }
	
	let!(:vendor) { FactoryGirl.create(:vendor, :name => "First Vendor") }
	let!(:vcontact) { FactoryGirl.create(:vendor_contact, :vendor => vendor, :email => "some@abc.com") }
	let!(:vcontact_role) { FactoryGirl.create(:vendor_contact_role, :vendor_contact => vcontact) }

	let!(:vendor2) { FactoryGirl.create(:vendor) }
	let!(:vcontact2) { FactoryGirl.create(:vendor_contact, :vendor => vendor2, :email => "other@def.com") }
	let!(:vcontact_role2) { FactoryGirl.create(:vendor_contact_role, :vendor_contact => vcontact2) }

	let!(:rfqform) { FactoryGirl.create(:rfqform_with_eaus, 
		:program => part.id, :req_by => employee.id, :engineer => employee.id, ) }
	let!(:rfqpart) { FactoryGirl.create(:rfqpart,
		rfqform: rfqform, part_number: part.id, rfqpartvendors: [vendor,vendor2].map(&:id))}
	let!(:rfqpart2) { FactoryGirl.create(:rfqpart,
		rfqform: rfqform, part_number: part2.id, rfqpartvendors: [vendor,vendor2].map(&:id))}

	let! (:vendor_user) { FactoryGirl.create(:vendor_user, :vendor_id => vendor.id) }

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
				it { should_not be_valid }
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

