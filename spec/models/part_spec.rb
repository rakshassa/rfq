require 'spec_helper'

describe Part do

	let!(:part) { FactoryGirl.create(:part, :name => "xxxx") }
	let!(:part2) { FactoryGirl.create(:part, :name => "PA01") }
	let!(:part3) { FactoryGirl.create(:part, :name => "PA02") }
	let!(:part4) { FactoryGirl.create(:part, :name => "CaCa") }

	subject { part }

	it { should respond_to(:rfqquotes) }
	it { should respond_to(:name) }
	it { should respond_to(:description) }


	it "limits to programs" do
		programs = Part.programs

		programs.should match_array([part2, part3])		
	end

end
