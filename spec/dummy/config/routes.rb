Rails.application.routes.draw do
  resources :posts do
    member do
      post :like
      post :unlike
    end
  end
  resources :cars

  authorize :rights do
    resources :users
  end
end
