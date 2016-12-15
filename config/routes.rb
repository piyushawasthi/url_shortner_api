require 'api_constraints'
Rails.application.routes.draw do
  
  resources :short_urls
  resources :short_urls,  :format => 'json'
  resources :users

  get    'signup'  => 'users#new'
  post   'signup'  => 'users#create'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  get    'sessions/new'
  get '/:shorty' => 'short_urls#redirect'
  get '/short_urls/:id/short_visits' => 'short_urls#short_visits'

  # You can have the root of your site routed with "root"
  root   'sessions#new'
  
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      match '/' => "shorts#create" , :via => ['post']
      match '/:slug' => "shorts#show" , :via => ['get']
    end
  end

end
