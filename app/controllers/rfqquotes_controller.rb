class RfqquotesController < ApplicationController

  def show
  	@rfqquote = Rfqquote.find(params[:id])
  	@rfqform = Rfqform.find(@rfqquote.rfqform_id)
  	@rfq_contact = VendorContact.find(:first, "vendor_id = ?", @rfqquote.vendor_id)
  	@rfqpart = Rfqpart.find(@rfqquote.part_id)
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
    @rfqquote = Rfqquote.find(params[:id])
    if (@rfqquote.submitted_to_tlx) then
      flash[:error] = "This quote has already been submitted."
      redirect_to rfqforms_path and return
    end

    if @rfqquote.update_attributes(rfqquote_params)
      @rfqquote.update_attributes(date_submitted: DateTime.now.to_date)
      flash[:success] = "Updated"
      redirect_to @rfqquote
    else
      @rfqform = Rfqform.find(@rfqquote.rfqform_id)
      @rfq_contact = VendorContact.find(:first, "vendor_id = ?", @rfqquote.vendor_id)
      @rfqpart = Rfqpart.find(@rfqquote.part_id)
      @part = Part.find(@rfqpart.part_number)
      render 'edit'
    end    
  end

  private

    def rfqquote_params
      params.require(:rfqquote).permit(:quote_note, :quote_number, :quote_date,
        :submitted_by, :valid_till, :no_exceptions, :feedback, 

        rfqquote_eaus_attributes: [:id, :parts_note, :unit_price, 
          :no_quote, :tooling, :nre ]
        )
    end     

end