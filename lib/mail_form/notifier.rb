module MailForm
	class Notifier < ActionMailer::Base
		append_view_path File.expand_path("../../views", __FILE__)
		
		def contact(contact) # Why is this not a class method?
			@contact = contact
			mail(@contact.headers)
		end
	end
end