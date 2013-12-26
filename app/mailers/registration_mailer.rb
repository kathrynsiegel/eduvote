class RegistrationMailer < ActionMailer::Base
  default from: "noreply@eduvote.herokuapp.com"

  	def welcome_email(user)
  		@user = user
    	@url  = 'http://eduvote.herokuapp.com'
    	mail(to: @user.email, subject: 'Welcome to EDUvote!')
  	end
end
