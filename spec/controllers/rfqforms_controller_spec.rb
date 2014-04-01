require 'spec_helper'

describe RfqformsController do
	include_context 'created_rfqform'

	it "should delete" do
		expect do
			xhr :delete, :destroy, id: rfqform.id
		end.to change(Rfqform, :count).by(-1)
	end

	it "should respond with success" do
		xhr :delete, :destroy, id: rfqform.id
		expect(response).to be_success
	end

	describe "after built" do
		before do
			rfqform.update_attribute(:built , true)
		end

		it "should fail" do
			xhr :delete, :destroy, id: rfqform.id
			expect(response).not_to be_success
		end

		it "should not delete" do
			expect do
				xhr :delete, :destroy, id: rfqform.id
			end.to_not change(Rfqform, :count)
		end
	end

	it "should create pdf" do		
		get :show, id: rfqform.id, :format => :pdf
		response.header['Content-Type'].should include 'application/pdf'
	end
end