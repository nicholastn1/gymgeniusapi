# frozen_string_literal: true

require 'sendgrid-ruby'

module Api
  module V1
    class PasswordResetsController < BaseController
      skip_before_action :authenticate_user!
      include SendGrid

      def new
        # Apenas para compatibilidade com a rota GET
        head :ok
      end

      def create
        user = User.find_by(email: params[:user][:email])
        if user
          user.generate_reset_password_token!
          UserMailer.reset_password_instructions(user).deliver_now
          render json: { message: 'Password reset instructions sent' }
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      def update
        user = User.find_by(reset_password_token: params[:user][:token])

        if user&.reset_password_token_valid?
          user.reset_password!(params[:user][:password])
          user.touch(:updated_at)
          user.update(reset_password_token: nil)
          render json: { message: 'Password reset successful' }
        else
          render json: { error: 'Invalid or expired reset token' }, status: :unprocessable_entity
        end
      end
    end
  end
end
