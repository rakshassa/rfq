require 'spec_helper'

describe ContactRole do

	let!(:vendor) { FactoryGirl.create(:vendor, :name => "First Vendor") }
	let!(:vcontact) { FactoryGirl.create(:vendor_contact, :vendor => vendor, :email => "some@abc.com") }
	
	let!(:contact_role) { FactoryGirl.create(:contact_role, :name => "first role") }
	let!(:contact_role2) { FactoryGirl.create(:contact_role, :name => "second role") }	

	let!(:vcontact_role) { FactoryGirl.create(:vendor_contact_role, 
		:vendor_contact => vcontact, :contact_role => contact_role2) }

	subject { contact_role2 }

	it { should respond_to(:vendor_contact_roles) }
	it { should respond_to(:name) }
	it { should respond_to(:id) }

	it "has associations" do
		contact_role2.vendor_contact_roles.size.should eq(1)
		vcrole = contact_role2.vendor_contact_roles.first
		vcrole.should eq(vcontact_role)
		vcrole.vendor_contact.should eq(vcontact)
		vcrole.vendor_contact.email.should eq("some@abc.com")
	end

	it "does not have associations" do
		contact_role.vendor_contact_roles.size.should eq(0)
	end

end
