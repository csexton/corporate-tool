Rails.application.routes.draw do
  root 'welcome#index'

  resources :pages
  resources :gists
  resources :uploads, except: [:edit, :update]

  get 'welcome/auth'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  get '/signout', to: 'sessions#destroy'

  get "*path" => "pages#display"
end
