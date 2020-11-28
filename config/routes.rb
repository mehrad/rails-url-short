Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'urls#index'
  get "/:short_url", to: "urls#show"
  get "s/:short_url", to: "urls#shortened", as: :shortened
  resources :urls, only: :create
end
