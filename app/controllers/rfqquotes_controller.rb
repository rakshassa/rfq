class RfqquotesController < ApplicationController

  def show
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
  	@rfqquote = Rfqquote.find(params[:id])    
  	prep_instance_vars(@rfqquote)  
    @action_type = "show" 

    respond_to do |format|
      format.pdf do        
        prawnto :prawn=>{:top_margin => 2}, filename: "TLX-RFQ-#{@rfqquote.whole_printable_id}.pdf", :inline => false
      end
      format.html
      
    end        	
  end

  def edit
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
  	@rfqquote = Rfqquote.find(params[:id])

    if (!authorize_change(@rfqquote)) then
      redirect_to rfqforms_path and return
    end

  	prep_instance_vars(@rfqquote)
    @action_type = "edit"     
  end

  def update
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
    @rfqquote = Rfqquote.find(params[:id])

    if (!authorize_change(@rfqquote)) then
      redirect_to rfqforms_path and return
    end

    @rfqquote.isTLX = current_user.isTLX
    @rfqquote.rfqquote_eaus.each { |eau| eau.isTLX = current_user.isTLX }

    if @rfqquote.update_attributes(rfqquote_params)
      flash[:success] = "Updated"
      redirect_to @rfqquote
    else      
      prep_instance_vars(@rfqquote)
      @action_type = "edit"
      render 'edit'
    end    
  end

  def submit_to_tlx
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
    @rfqquote = Rfqquote.find(params[:id])

    if (!authorize_submit_to_tlx(@rfqquote)) then
        @action_type = "show" 
        prep_instance_vars(@rfqquote)
        render 'show' and return
    end

    @rfqquote.submitted_to_tlx = true
    @rfqquote.date_submitted = DateTime.now.to_date
    @rfqquote.save

    RfqMailer.submit_quote(@rfqquote).deliver
    flash[:success] = "Submitted"
    redirect_to rfqforms_path
  end

  def send_feedback
    if (!validate_user()) then redirect_to APP_CONFIG['login_redirect'] and return end
    @rfqquote = Rfqquote.find(params[:id])
    
    if (!authorize_feedback(@rfqquote)) then
        @action_type = "show" 
        prep_instance_vars(@rfqquote)
        render 'show' and return
    end

    @rfqquote.feedback_sent = true
    @rfqquote.date_feedback_sent = DateTime.now.to_date
    @rfqquote.save

    RfqMailer.send_feedback(@rfqquote).deliver
    flash[:success] = "Feedback Sent"
    redirect_to rfqforms_path
  end


  private
    def prep_instance_vars(rfqquote)      
      @rfqform = rfqquote.rfqform
      @rfq_contact = rfqquote.vendor.rfq_contact          
      @rfqpart = rfqquote.rfqpart
      @part = rfqquote.rfqpart.part     
      @vendor = rfqquote.vendor
    end

    def rfqquote_params
      params.require(:rfqquote).permit(:quote_note, :quote_number, :quote_date,
        :submitted_by, :valid_till, :exceptions,

        rfqquote_eaus_attributes: [:id, :parts_note, :unit_price, 
          :no_quote, :tooling, :nre, :feedback ]
        )
    end     

    def authorize_change(rfqquote)
      if (rfqquote.feedback_sent) then
        flash[:error] = "This quote is closed."
        return false
      end     

      if (rfqquote.submitted_to_tlx && !current_user.isTLX) then
        flash[:error] = "This quote has already been submitted."
        return false
      end

      return true
    end

    def authorize_submit_to_tlx(rfqquote)
      if (rfqquote.submitted_to_tlx?) then
          flash.now[:error] = "Your quote was previously submitted."
          return false
      end

      if (rfqquote.quote_number.blank?) then
        flash.now[:error] = "Please enter quote information before submitting to TLX."
        return false
      end 

      return true         
    end

    def authorize_feedback(rfqquote)
      if (rfqquote.feedback_sent?) then
          flash.now[:error] = "Feedback was already sent on this RFQ."
          return false
      end

      rfqquote.rfqquote_eaus.each do |rfqquote_eau|
        if (rfqquote_eau.feedback.blank?) then
          flash.now[:error] = "Please enter feedback for all quotes before sending feedback."
          return false
        end
      end   

      return true   
    end


end
