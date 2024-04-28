class ApplicationController < ActionController::API

  def current_user
    raise NotImplementedError, 'You must implement current_user in your ApplicationController'
  end
end
