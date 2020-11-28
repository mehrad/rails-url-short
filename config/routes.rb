class UrlAdminConstraint
  def matches?(request)
    request[:short_url][-1] == '+'
  end
end

Rails.application.routes.draw do
  devise_for :users
  root to: 'urls#index'

  # Like bit.ly add + at end of to see the shortened panel
  constraints(UrlAdminConstraint.new) do
    get "/:short_url", to: "urls#shortened", as: "shortened"
  end

  get "/:short_url", to: "urls#show"

  resources :urls, only: :create
end

