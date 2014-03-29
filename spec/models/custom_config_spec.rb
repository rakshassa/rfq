require 'spec_helper'

describe "StartSearches" do


	it "handles true cases" do

		"true".to_bool.should be_true
		"t".to_bool.should be_true
		"1".to_bool.should be_true
		
	end

	it "handles false cases" do

		"false".to_bool.should be_false
		"f".to_bool.should be_false
		"0".to_bool.should be_false
		
	end

	it "handles fail cases" do
		
		
		expect { "jealous".to_bool }.to raise_error(ArgumentError)
		
	end

end
 