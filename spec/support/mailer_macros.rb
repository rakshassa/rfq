module MailerMacros
	def last_email
		ActionMailer::Base.deliveries.last_email
	end

	def reset_email
		ActionMailer::Base.deliveries = []

	end
end
