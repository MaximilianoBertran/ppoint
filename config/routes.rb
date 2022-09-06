Rails.application.routes.draw do

  resource :users, only: [:create]
  post '/login', to: 'users#login'
  post '/auto_login', to: 'users#auto_login'
  
  get '/purchases', to: 'purchases#index'
  
  get '/purchases/top_sell', to: 'purchases#top_sell'
  get '/purchases/top_amount', to: 'purchases#top_amount'

  get '/purchases/:granularity', to: 'purchases#graphic'

end
