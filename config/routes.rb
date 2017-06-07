Rails.application.routes.draw do

  root 'welcome#index'

  resources :pages do
    member do
      get 'versions/:version_id(.:format)', action: :version, as: :version
      get 'versions', action: :versions, as: :versions
    end
  end
  resources :gists
  resources :uploads, except: [:edit, :update]
  resource  :profile, only: [:show, :update]
  get '/directory', to: "directory#index"
  get '/directory/:id', to: "directory#show"
  post 'preview', to: 'preview#show'
  get '/search', to: 'search#show'

  get 'welcome/auth'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/signout', to: 'sessions#destroy'

  get "*path" => "pages#display"
end
