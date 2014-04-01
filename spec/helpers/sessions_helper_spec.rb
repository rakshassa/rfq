require 'spec_helper'
include SessionsHelper

describe "Sessions Helper" do
	let!(:defaultUser) { User.create(name: "testTLX") }
	let!(:otherUser) { User.create(name: "OtherGuy") }
	

	it "should have default user" do
		set_user(defaultUser)
		current_user.name.should eq("testTLX")
		current_user?(defaultUser).should be_true
	end

	it "should set a new user" do
		set_user(otherUser)

		current_user.name.should eq("OtherGuy")
		current_user?(otherUser).should be_true
		current_user?(defaultUser).should be_false
	end

end