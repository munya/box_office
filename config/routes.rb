Rails.application.routes.draw do

  resources :events do 
    resources :purchases do
      resources :tickets
    end  
  end  

  root to: 'events#index'
end
