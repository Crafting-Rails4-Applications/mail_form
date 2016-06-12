require 'test_helper'
require 'fixtures/sample_mail'

class MailFormTest < ActiveSupport::TestCase
	setup do
		ActionMailer::Base.deliveries.clear
	end
    
    test "truth" do
      assert_kind_of Module, MailForm
    end

  test "sample mail has name and email as attributes" do
  	sample = SampleMail.new
  	sample.name = "User"
  	sample.email = "user@example.com"

  	assert_equal "User", sample.name
  	assert_equal "user@example.com", sample.email
  	
  	assert sample.name?
  	assert sample.email?

  	sample.clear_name
  	sample.clear_email

  	assert_nil sample.name
  	assert_nil sample.email
  end

  test "delivers an email with attributes" do
  	sample = SampleMail.new
  	sample.email = "user@example.com"
  	sample.deliver

  	assert_equal 1, ActionMailer::Base.deliveries.size
  	mail = ActionMailer::Base.deliveries.last

  	assert_equal mail.from, ["user@example.com"]
	assert_match "Email: user@example.com", mail.body.encoded
  end
end
