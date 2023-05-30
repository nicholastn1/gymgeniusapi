Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/current_user', to: 'current_user#index'
  get '/password/forgot', to: 'password_resets#new'
  post '/password/forgot', to: 'password_resets#create'
  patch '/password/reset', to: 'password_resets#update'
end