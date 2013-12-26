class ApplicationController < ActionController::Base
  	# Prevent CSRF attacks by raising an exception.
  	protect_from_forgery with: :exception
  	
  	include SessionsHelper

  	# test whether user is signed in
  	before_filter :signed_in_user
end
