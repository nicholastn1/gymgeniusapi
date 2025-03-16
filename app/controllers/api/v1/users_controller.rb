# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      def current
        render json: current_user, status: :ok
      end

      def update
        if current_user.update(user_params)
          render json: {
            status: { code: 200, message: 'Usuário atualizado com sucesso.' },
            data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: { message: "Não foi possível atualizar o usuário. #{current_user.errors.full_messages.to_sentence}" }
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :image)
      end
    end
  end
end
