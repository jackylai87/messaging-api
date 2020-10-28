Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :twilio do
    resources :messages, only: [:create]
  end

  resources :conversations, except: [:create] do
    member do
      post 'send_message', to: 'conversations#send_message'
    end
  end

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
