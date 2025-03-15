# frozen_string_literal: true

module Api
  module V1
    class HealthController < BaseController
      skip_before_action :authenticate_user!

      def index
        render json: {
          status: 'ok',
          version: '1.0.0',
          environment: Rails.env,
          timestamp: Time.current
        }, status: :ok
      end
    end
  end
end
