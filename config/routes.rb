# TIC_TAC_TOE routes
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :players, except: [:new, :edit] do
    member do
      post :create_board
    end
  end
  resources :boards, except: [:new, :edit] do
    member do
      post :play
      get :refresh
    end
  end

  post '/players/login', to: 'players#login'
end
