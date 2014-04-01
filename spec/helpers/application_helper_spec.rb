require 'spec_helper'
include ApplicationHelper

describe "Application Helper" do
	it "should have base title" do
		full_title("").should eq("Vendor Portal")
	end

	it "should have compound title" do
		full_title("Test").should eq("Vendor Portal | Test")
	end
end