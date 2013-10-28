class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include ControlarAcceso
  
  before_filter :controlar_acceso!
  
  def after_sign_out_path_for(resource_or_scope)    
    login_path
  end
  
end
