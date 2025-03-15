# frozen_string_literal: true

module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_user!, only: [:create]
      respond_to :json

      def create
        user = User.find_by(email: params[:user][:email])
        if user&.valid_password?(params[:user][:password])
          sign_in(user)
          render json: {
            status: { code: 200, message: 'Logged in sucessfully.' },
            data: UserSerializer.new(user).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: { code: 401, message: 'Invalid email or password.' }
          }, status: :unauthorized
        end
      end

      def destroy
        if current_user
          sign_out(current_user)
          render json: {
            status: 200,
            message: 'logged out successfully'
          }, status: :ok
        else
          render json: {
            status: 401,
            message: "Couldn't find an active session."
          }, status: :unauthorized
        end
      end
    end
  end
end
