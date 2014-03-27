include SessionsHelper
require 'spec_helper'

describe Rfqquote do
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
	let!(:rfqquote) { quotes.first }
	let!(:rfqquote_eau) { quotes[1].rfqquote_eaus.first }	

	subject { rfqquote }

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
		before do APP_CONFIG['default_user_name'] = tlx_user.name end

		its(:valid_user) { should be_false }
	end
	describe "as vendor" do
		before do APP_CONFIG['default_user_name'] = vendor_user.name end

		its(:valid_user) { should be_true }
	end

	describe "printable id" do
		before { rfqquote.rfqquote_display_id = 16 }
		its(:printable_id) { should eq "016"}
		its(:whole_printable_id) { should eq(rfqform.printable_id + "-016") }
	end


	describe "when quote number is missing" do
		before { rfqquote.quote_number = nil }

		describe "as tlx" do
			before { APP_CONFIG['default_user_name'] = tlx_user.name }
			it { should be_valid }
		end
		describe "as vendor" do
			before { APP_CONFIG['default_user_name'] = vendor_user.name }
			it { should_not be_valid }
		end		
	end

	describe "when quote_date is missing" do
		before { rfqquote.quote_date = nil }
		describe "as tlx" do
			before { APP_CONFIG['default_user_name'] = tlx_user.name }
			it { should be_valid }
		end
		describe "as vendor" do
			before { APP_CONFIG['default_user_name'] = vendor_user.name }
			it { should_not be_valid }
		end		
	end

	describe "when submitted_by is missing" do
		before { rfqquote.submitted_by = nil }
		describe "as tlx" do
			before { APP_CONFIG['default_user_name'] = tlx_user.name }
			it { should be_valid }
		end
		describe "as vendor" do
			before { APP_CONFIG['default_user_name'] = vendor_user.name }
			it { should_not be_valid }
		end	
	end

	describe "when valid_till is missing" do
		before { rfqquote.valid_till = nil }
		describe "as tlx" do
			before { APP_CONFIG['default_user_name'] = tlx_user.name}
			it { should be_valid }
		end
		describe "as vendor" do
			before { APP_CONFIG['default_user_name'] = vendor_user.name }
			it { should_not be_valid }
		end	
	end	

end

