require 'spec_helper'

describe RfqquotesController do
	include_context 'created_rfqform'

	let!(:quotes) { rfqform.build }
	let!(:rfqquote) { quotes.first }


	it "should create pdf" do		
		get :show, id: rfqquote.id, :format => :pdf
		response.header['Content-Type'].should include 'application/pdf'
	end
end