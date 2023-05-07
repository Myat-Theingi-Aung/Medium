# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  get '/categories', to: 'categories#index'
  post '/users', to: 'users#create'
  get '/users', to: 'users#index'
  delete 'user/:id/image', to: 'users#image_delete'
  post 'users/:id', to: 'users#update'
  post '/login', to: 'signin#login'
  get '/users/:id', to: 'users#profile'
  patch '/user/:id/password', to: 'users#password'
  post '/user/forgot/password', to: 'users#forgot_password'
  patch '/user/reset/password/:id', to: 'users#reset_password'
  delete '/users/:id', to: 'users#destroy'
  get '/home', to: 'posts#home'
  get '/category/:name', to: 'posts#category_list'
  post '/post/import', to: 'posts#import'
  post '/post/export', to: 'posts#export'
  get '/comments/:id', to: 'comments#index'
  post '/comments', to: 'comments#create'
  post '/comments/reply', to: 'comments#reply'
  put '/comments/:id', to: 'comments#update'
  get '/comments/child/reply', to: 'comments#child_reply'
  delete '/comments/:id', to: 'comments#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
