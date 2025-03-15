# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      # Métodos e configurações comuns para todos os controladores da API V1
      include ActionController::MimeResponds
      respond_to :json

      # Autenticação Devise
      before_action :authenticate_user!, unless: :devise_controller?

      # Tratamento de erros para a API
      rescue_from StandardError, with: :render_standard_error
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

      private

      def render_standard_error(exception)
        render json: { error: exception.message }, status: :internal_server_error
      end

      def render_not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def render_parameter_missing(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
      end

      def authenticate_user!
        if user_signed_in?
          super
        else
          render json: { error: 'Você precisa fazer login para continuar.' }, status: :unauthorized
        end
      end
    end
  end
end
