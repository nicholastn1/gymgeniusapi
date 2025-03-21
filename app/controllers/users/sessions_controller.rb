# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def respond_with(resource, _opts = {})
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok, headers:
    end

    def respond_to_on_destroy
      if current_user
        render_logout_success
      else
        render_session_not_found
      end
    end

    private

    def render_logout_success
      render json: {
        status: 200,
        message: 'logged out successfully'
      }, status: :ok
    end

    def render_session_not_found
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
