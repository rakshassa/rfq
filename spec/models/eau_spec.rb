require 'spec_helper'

describe Eau do

	let!(:rfqform) { FactoryGirl.create(:rfqform) }
	let!(:eau) { FactoryGirl.create(:eau, :value => 12, :rfqform => rfqform) }

	subject { eau }

	it { should respond_to(:rfqform_id) }
	it { should respond_to(:value) }
	it { should respond_to(:id) }
	it { should respond_to(:rfqform) }
	it { should respond_to(:rfqquoteEaus) }

	it "has associations" do
		eau.rfqform.should eq(rfqform)
	end

	it "does not allow non integer values" do
		eau.should be_valid
		eau.value = 12345678
		eau.should be_valid

		eau.value = 12.4
		eau.should be_invalid

		eau.value = "abc"
		eau.should be_invalid

		eau.value = 12
		eau.should be_valid

		eau.value = -3
		eau.should be_invalid
	end
 
end
