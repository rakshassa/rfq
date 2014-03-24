class RfqMailer < ActionMailer::Base
  default from: APP_CONFIG['default_email_from']

  def send_new_rfq(rfqform)
  	@rfqform = rfqform
  	@quote_number = @rfqform.printable_id
  	@targets = []
  	@rfqform.rfqparts.each do |rfqpart|
  		rfqpart.rfqpartvendors.reject(&:blank?).each do |vendor|  			
  			@targets << VendorContact.find(vendor).email
  		end
  	end

  	mail(from: APP_CONFIG['default_email_from'], to: @targets, 
  		subject: "TLX is requesting a quote: " + @quote_number)
  end

  def submit_quote(rfqquote)
  	@rfqquote = rfqquote
  	@quote_number = @rfqquote.whole_printable_id
  	@target = APP_CONFIG['default_email_from']  	
  	@sender = VendorContact.find(@rfqquote.vendor_id).email

  	mail(to: @target, from: @sender,
  		subject: "RFQ Quote " + @quote_number + " has been submitted.",
  		content_type: "text/html",
  		body: "RFQ Quote " + @quote_number + " submission has been received.")
  end

  def send_feedback(rfqquote)
  	@rfqquote = rfqquote
  	@quote_number = @rfqquote.whole_printable_id
  	@target = VendorContact.find(@rfqquote.vendor_id).email
  	mail(from: APP_CONFIG['default_email_from'], to: @target, 
  		subject: "Feedback received on RFQ Quote " + @quote_number)
  end  

end
