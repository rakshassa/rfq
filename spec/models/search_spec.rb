include SessionsHelper
require 'spec_helper'

describe Search do
	before do
		
		@tlx_user = User.create(name: "testTLX", isTLX: true)
		@vendor_user = User.create(name: "testVendor1", isTLX: false, vendor_id: 1)
		
		@search = Search.new
	end

	subject { @search }

	it { should respond_to(:built) }
	it { should respond_to(:vendor) }
	it { should respond_to(:program) }
	it { should respond_to(:rfq) }
	it { should respond_to(:quote_number) }
	it { should respond_to(:date_built) }
	it { should respond_to(:date_quoted) }

	it { should be_valid }

	describe "check valid date built" do
		before do @search.date_built = "1989/03/21 - 1992/05/30" end

		its(:check_dates) { should be_true }
	end

	describe "check invalid date built usa" do
		before do @search.date_built = "03/21/2012 - 05/30/2013" end

		its(:check_dates) { should be_false }
	end	

	describe "check valid date built" do
		before do @search.date_built = "" end

		its(:check_dates) { should be_true }
	end	

	describe "check valid date built" do
		before do @search.date_built = nil end

		its(:check_dates) { should be_true }
	end		

	describe "check long date built invalid" do
		before do @search.date_built = "03/21/1989 - 05/30/1992 - 07/12/1998" end

		its(:check_dates) { should be_false }
	end

	describe "check short date built invalid" do
		before do @search.date_built = "03/21/1989" end

		its(:check_dates) { should be_false }
	end	

	describe "check invalid start date built" do
		before do @search.date_built = "03xxx989 - 00/30/1992" end

		its(:check_dates) { should be_false }
	end	

	describe "check invalid end date built" do
		before do @search.date_built = "03/21/1989 - 00/3xxxx" end

		its(:check_dates) { should be_false }
	end		
=begin

	describe "search for date built" do		
		let!(:date_search) do Search.create(date_built: "1989/03/21 - 2072/05/30") end
		let!(:rfqform) do FactoryGirl.create(:rfqform_with_associations, rfqforms_count: 2) end

		before do 			
			rfqform.built = true
			rfqform.date = DateTime.now.to_date
			rfqform.save

			rfqquote = Rfqquote.create(rfqform_id: rfqform.id, part_id: 1, vendor_id: 1)
			rfqquote2 = Rfqquote.create(rfqform_id: rfqform.id, part_id: 1, vendor_id: 2)
		end


		subject {date_search.forms }
		its(:size) { should eq(1) }

		subject { date_search.GetQuotes(date_search.forms) }
		its(:size) { should eq(1) }

		it "should be an array" do
			#forms = date_search.forms
			#expect(forms.count).to eq(1)
			#quotes = date_search.GetQuotes(date_search.forms)
			#expect(quotes.count).to eq(1)
			#expect(quotes[rfqform.id]).to eq(2)

			expect(Rfqquote.where("rfqform_id=?", rfqform.id).count).to eq(2)

			#expect(date_search.GetQuotes(date_search.forms)[rfqform.id].size).to eq(2)
		end
		#its("[rfqform.id]") { should eq(2) }
	end
=end


end

