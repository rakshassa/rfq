shared_context 'created_rfqform' do

	let (:tlx_user) { FactoryGirl.create(:tlx_user) }
	before do 		
		APP_CONFIG['default_user_name'] = tlx_user.name 
	end

	let!(:part) { FactoryGirl.create(:part, :name => "PA01") }
	let!(:part2) { FactoryGirl.create(:part, :name => "PA02") }
	let!(:employee) { FactoryGirl.create(:employee, :first_name => "Bob", :last_name => "Smith") }
	
	let!(:contact_role) { FactoryGirl.create(:contact_role, :name => "First") }
	let!(:contact_role1) { FactoryGirl.create(:contact_role, :name => "Second") }
	let!(:contact_role2) { FactoryGirl.create(:contact_role, :name => "Third") }
	let!(:contact_role3) { FactoryGirl.create(:contact_role, :name => "Fourth", :id => 4) }
	let!(:contact_role4) { FactoryGirl.create(:contact_role, :name => "Fifth") }
	let!(:rfq_role) { ContactRole.find(APP_CONFIG['rfq_contact_role'])}


	let!(:vendor) { FactoryGirl.create(:vendor, :name => "First Vendor") }
	let!(:vendor_address) { FactoryGirl.create(:vendor_address, :vendor => vendor)}
	let!(:vcontact) { FactoryGirl.create(:vendor_contact, :vendor => vendor, :email => "some@abc.com") }
	let!(:vcontact_role) { FactoryGirl.create(:vendor_contact_role, :contact_role => rfq_role, :vendor_contact => vcontact) }

	let!(:vendor2) { FactoryGirl.create(:vendor) }
	let!(:vendor_address2) { FactoryGirl.create(:vendor_address, :vendor => vendor2)}
	let!(:vcontact2) { FactoryGirl.create(:vendor_contact, :vendor => vendor2, :email => "other@def.com") }
	let!(:vcontact_role2) { FactoryGirl.create(:vendor_contact_role, :contact_role => rfq_role, :vendor_contact => vcontact2) }

	let!(:rfqform) { FactoryGirl.create(:rfqform_with_eaus, 
		:program => part.id, :req_by => employee.id, :engineer => employee.id, :eaus_count => 3 ) }
	let!(:rfqpart) { FactoryGirl.create(:rfqpart,
		rfqform: rfqform, part_number: part.id, rfqpartvendors: [vendor,vendor2].map(&:id))}
	let!(:rfqpart2) { FactoryGirl.create(:rfqpart,
		rfqform: rfqform, part_number: part2.id, rfqpartvendors: [vendor,vendor2].map(&:id))}

	let (:vendor_user) { FactoryGirl.create(:vendor_user, :vendor_id => vendor.id) }
end
