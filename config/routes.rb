# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Rotas da API versionada
  namespace :api do
    namespace :v1 do
      # Rota de saúde
      get '/health', to: 'health#index'

      # Rotas de autenticação
      post '/signup', to: 'registrations#create'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'

      # Rotas de usuário
      get '/current_user', to: 'users#current'
      patch '/users', to: 'users#update'

      # Rotas de redefinição de senha
      get '/password/forgot', to: 'password_resets#new'
      post '/password/forgot', to: 'password_resets#create'
      patch '/password/reset', to: 'password_resets#update'
    end
  end

  # Configuração do Devise (mantida para compatibilidade)
  devise_for :users, path: '', path_names: {
                               sign_in: 'login',
                               sign_out: 'logout',
                               registration: 'signup'
                             },
                   controllers: {
                     sessions: 'users/sessions',
                     registrations: 'users/registrations'
                   }, skip: [:sessions, :registrations]

  # Redirecionamentos para manter compatibilidade com clientes existentes
  get '/health', to: redirect('/api/v1/health')
  get '/current_user', to: redirect('/api/v1/current_user')
  get '/password/forgot', to: redirect('/api/v1/password/forgot')
  post '/password/forgot', to: redirect('/api/v1/password/forgot')
  patch '/password/reset', to: redirect('/api/v1/password/reset')
end
