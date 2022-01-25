Rails.application.routes.draw do

  scope "/api", defaults: {format: :json} do
    resources :numbers, only: [:index]
  end
end
