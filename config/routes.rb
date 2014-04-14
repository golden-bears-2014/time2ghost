Time2ghost::Application.routes.draw do
  root :to => 'homepage#index'
  resources :trips
  resources :users
  resources :sessions, :only => [:create, :destroy]
  get 'twiliotest', to: 'twilio#show'
  get '/profile', to: 'users#profile'
  match "new-fake-trip" => "trips#createfake"
end
