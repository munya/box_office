Rails.application.routes.draw do

  resources :events do 
    resources :purchases
  end  

  root to: 'events#index'
end
