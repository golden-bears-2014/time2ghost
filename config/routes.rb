Time2ghost::Application.routes.draw do
  root :to => 'homepage#index'
  resources :bart_trips
  resources :users
  resources :stations, :only => [:index]
  resources :sessions, :only => [:create, :destroy]
  get 'twiliotest', to: 'twilio#show'
  get '/profile', to: 'users#profile'
  match 'new-fake-trip' => 'trips#new_fake', :as => 'new_fake_trip'
  match 'create-fake-trip' => 'trips#create_fake', :as => 'create_fake_trip'
end
