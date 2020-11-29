class UrlAdminConstraint
  def matches?(request)
    request[:short_url][-1] == '+'
  end
end

Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "urls#my_url", as: :authenticated_root
  end

  unauthenticated :user do
    root to: 'urls#new'
  end

  # Like bit.ly add + at end of to see the shortened panel
  constraints(UrlAdminConstraint.new) do
    get "/:short_url", to: "urls#shortened", as: "shortened"
  end

  get "/:short_url", to: "urls#show"

  resources :urls, only: :create

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :url_items, only: [:index, :show, :create, :update, :destroy], param: :short_url
    end
  end

end

