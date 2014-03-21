class RfqquotesController < ApplicationController

  def show
  	@rfqquote = Rfqquote.find(params[:id])
  	prep_instance_vars(@rfqquote)  
    @action_type = "show" 

    respond_to do |format|
      format.pdf do        
        prawnto filename: "TLX-RFQ-#{@rfqform.id.to_s.rjust(4, '0') + "-" + @rfqquote.rfqquote_display_id.to_s.rjust(3,'0')}.pdf", :inline => false
      end
      format.html
      
    end        	
  end

  def edit
  	@rfqquote = Rfqquote.find(params[:id])
  	prep_instance_vars(@rfqquote)
    @action_type = "edit"     
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
      prep_instance_vars(@rfqquote)
      @action_type = "edit"
      render 'edit'
    end    
  end

  private
    def prep_instance_vars(rfqquote)
      @rfqform = Rfqform.find(rfqquote.rfqform_id)
      @rfq_contact = VendorContact.find(:first, "vendor_id = ?", rfqquote.vendor_id)
      @rfqpart = Rfqpart.find(rfqquote.part_id)
      @part = Part.find(@rfqpart.part_number)
      @vendor = Vendor.find(rfqquote.vendor_id)
    end

    def rfqquote_params
      params.require(:rfqquote).permit(:quote_note, :quote_number, :quote_date,
        :submitted_by, :valid_till, :exceptions,

        rfqquote_eaus_attributes: [:id, :parts_note, :unit_price, 
          :no_quote, :tooling, :nre, :feedback ]
        )
    end     

end
