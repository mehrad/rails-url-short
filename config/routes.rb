class UrlAdminConstraint
  def matches?(request)
    puts request[:short_url]
    request[:short_url][-1] == '+'
  end
end

Rails.application.routes.draw do
  root to: 'urls#index'

  # Like bit.ly add + at end of to see the shortened panel
  constraints(UrlAdminConstraint.new) do
    get "/:short_url", to: "urls#shortened", as: "shortened"
  end

  get "/:short_url", to: "urls#show"

  resources :urls, only: :create
end

