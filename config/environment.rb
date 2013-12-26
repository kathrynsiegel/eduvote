# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
KathrynsiegelCmobrienQuiAnnietang92Final::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'app19500860@heroku.com',
  :password       => 'tzvoogbr',
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}