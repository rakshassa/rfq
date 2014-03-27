require 'spec_helper'

describe Rfqpart do
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

	subject { rfqpart }

	it { should respond_to(:rfqform) }
	it { should respond_to(:part) }
	it { should respond_to(:rfqquote) }
	it { should respond_to(:rfqform_id) }
	it { should respond_to(:part_number) }
	it { should respond_to(:revision) }
	it { should respond_to(:qty) }
	it { should respond_to(:units) }
	it { should respond_to(:rfqpartvendors) }
	it { should respond_to(:drawing) }

	it { should be_valid }	

	describe "part number" do
		before { rfqpart.part_number = nil }
		it { should be_invalid }		
	end

	describe "revision" do	
		before { rfqpart.revision = nil }
		it { should be_invalid }		
	end	

	describe "units" do		
		before { rfqpart.units = nil }
		it { should be_invalid }		
	end		


	describe "when qty" do
		describe "is a positive float number" do
			before { rfqpart.qty = 3.4567 }
			it { should be_valid }
		end
		describe "is a negative number" do
			before { rfqpart.qty = -3 }
			it { should_not be_valid }
		end
		describe "is not a number" do
			before { rfqpart.qty = "bob" }
			it { should_not be_valid }
		end
		describe "is a positive integer" do
			before { rfqpart.qty = 1234123 }
			it { should be_valid }
		end		
	end		

end

	

	  