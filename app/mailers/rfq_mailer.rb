class RfqMailer < ActionMailer::Base
  default from: APP_CONFIG['default_email_from']

  def send_new_rfq(rfqform)
  	@rfqform = rfqform
  	@quote_number = @rfqform.printable_id
  	@targets = []
  	@rfqform.rfqparts.each do |rfqpart|
  		rfqpart.rfqpartvendors.reject(&:blank?).each do |vendor|  
        v = Vendor.find(vendor)			
        if (!v.blank? && !v.rfq_contact.blank?) then
  			  @targets << Vendor.find(vendor).rfq_contact.email
       
        end
  		end
  	end

  	mail(from: APP_CONFIG['default_email_from'], bcc: @targets, 
  		subject: "New RFQ Request (" + @quote_number + ")")
  end

  def submit_quote(rfqquote)
  	@rfqquote = rfqquote
  	@quote_number = @rfqquote.whole_printable_id
  	@target = APP_CONFIG['default_email_from']  	

    if (!@rfqquote.vendor.blank? && !@rfqquote.vendor.rfq_contact.blank?) then
      @sender = @rfqquote.vendor.rfq_contact.email    

    	mail(to: @target, from: @sender,
    		subject: "RFQ Quote (" + @quote_number + ") submittal.",
    		content_type: "text/html",
    		body: @rfqquote.vendor.name + 
          " has submitted a quote for RFQ " + 
          @quote_number + " for your review")
    
    end    
  end

  def send_feedback(rfqquote)
  	@rfqquote = rfqquote
  	@quote_number = @rfqquote.whole_printable_id

    if (!@rfqquote.vendor.blank? && !@rfqquote.vendor.rfq_contact.blank?) then
    	@target = @rfqquote.vendor.rfq_contact.email
    	mail(from: APP_CONFIG['default_email_from'], to: @target, 
    		subject: "RFQ Feedback from TLX")
    
    end
  end  

end
