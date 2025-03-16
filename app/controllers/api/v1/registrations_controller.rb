# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < BaseController
      skip_before_action :authenticate_user!, only: [:create]
      respond_to :json

      def create
        user = User.new(user_params)
        if user.save
          render json: {
            status: { code: 200, message: 'Signed up sucessfully.' },
            data: UserSerializer.new(user).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: { message: "User couldn't be created successfully. #{user.errors.full_messages.to_sentence}" }
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :name, :image)
      end
    end
  end
end
