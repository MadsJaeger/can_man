module CanMan
  class FailureApp < ActionController::API
    UNAUTHORIZED_MESSAGE = ->(controller) { "You don't have the right #{controller.params[:controller]}##{controller.params[:action]}" }

    def index
      render json: { error: UNAUTHORIZED_MESSAGE.call(self) }, status: :forbidden
    end
  end
end
