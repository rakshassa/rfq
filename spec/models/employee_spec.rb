require 'spec_helper'

describe Employee do
	let!(:emp) { FactoryGirl.create(:employee, :first_name => "xxxx", :inactive => true) }
	let!(:emp2) { FactoryGirl.create(:employee, :first_name => "bbbb", :inactive => false) }
	let!(:emp3) { FactoryGirl.create(:employee, :first_name => "YaYa", :inactive => true) }
	let!(:emp4) { FactoryGirl.create(:employee, :first_name => "CaCa", :inactive => false) }

	subject { emp }

	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:email) }
	it { should respond_to(:inactive) }
	it { should respond_to(:rfqforms) }
	it { should respond_to(:name) }


	it "limits to active" do
		emps = Employee.active

		emps.should match_array([emp2, emp4])		
	end

	it "sorts" do
		emps = Employee.sorted
		expect(emps).to match_array([emp, emp2, emp3, emp4])
		emps[0].should eq(emp2)
		emps[1].should eq(emp4)
		emps[2].should eq(emp)		
		emps[3].should eq(emp3)
	end

	it "sorts and limits to active" do 
		emps = Employee.sorted.active
		expect(emps).to match_array([emp2, emp4])
		emps[0].should eq(emp2)
		emps[1].should eq(emp4)
	end

end

