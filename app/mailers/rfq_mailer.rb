class RfqMailer < ActionMailer::Base
  default from: "no_reply@tlxtech.com"

  def send_new_rfq(rfqform)
  	@rfqform = rfqform
  	@quote_number = @rfqform.id.to_s.rjust(4,'0')
  	@targets = []
  	@rfqform.rfqparts.each do |rfqpart|
  		rfqpart.rfqpartvendors.reject(&:blank?).each do |vendor|  			
  			@targets << VendorContact.find(vendor).email
  		end
  	end

  	mail(from: "no_reply@tlxtech.com", to: @targets, subject: "TLX is requesting a quote: " + @quote_number)
  end

  def submit_quote(rfqquote)
  	@rfqquote = rfqquote
  	@quote_number = @rfqquote.rfqform_id.to_s.rjust(4,'0') + "-" + @rfqquote.rfqquote_display_id.to_s.rjust(3,'0')
  	#@target = "purchasing@tlxtech.com" 
  	@target = "rakshassa@gmail.com"
  	@sender = VendorContact.find(@rfqquote.vendor_id).email

  	mail(to: @target, from: @sender,
  		subject: "RFQ Quote " + @quote_number + " has been submitted.",
  		content_type: "text/html",
  		body: "RFQ Quote " + @quote_number + " submission has been received.")
  end

  def send_feedback(rfqquote)
  	@rfqquote = rfqquote
  	@quote_number = @rfqquote.rfqform_id.to_s.rjust(4,'0') + "-" + @rfqquote.rfqquote_display_id.to_s.rjust(3,'0')
  	@target = VendorContact.find(@rfqquote.vendor_id).email
  	mail(to: @target, subject: "Feedback received on RFQ Quote " + @quote_number)
  end  

end
