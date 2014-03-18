class RfqquotesController < ApplicationController

  def show
  	@rfqquote = Rfqquote.find(params[:id])
  	@rfqform = Rfqform.find(@rfqquote.rfqform_id)
  	@rfq_contact = VendorContact.find(:first, "vendor_id = ?", @rfqquote.vendor_id)
  	@rfqpart = Rfqpart.find(@rfqquote.rfqpart_id)
  	@part = Part.find(@rfqpart.part_number)  	
  end

  def edit
  	@rfqquote = Rfqquote.find(params[:id])
  	@rfqform = Rfqform.find(@rfqquote.rfqform_id)
  	@rfq_contact = VendorContact.find(:first, "vendor_id = ?", @rfqquote.vendor_id)
  	@rfqpart = Rfqpart.find(@rfqquote.part_id)
  	@part = Part.find(@rfqpart.part_number)
  end

  def update
  end

end
