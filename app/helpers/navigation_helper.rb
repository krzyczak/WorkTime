module NavigationHelper
  #def self.included(controller)
    #controller.send :helper, :redirect_to_target_or_default, :store_target_location
  #end
  
  def redirect_to_target_or_default(default, notice)
    redirect_to(session[:return_to] || default, notice)
    session[:return_to] = nil
  end
  
  def store_target_location
    #session[:return_to] = request.request_uri
    session[:return_to] = request.url
  end
end
