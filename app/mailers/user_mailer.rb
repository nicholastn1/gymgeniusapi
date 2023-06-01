# frozen_string_literal: true

require 'sendgrid-ruby'
require 'dotenv/load'

class UserMailer < ApplicationMailer
  include SendGrid

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def reset_password_instructions(user)
    mail = SendGrid::Mail.new
    mail.from = SendGrid::Email.new(email: 'gymgeniusapi@gmail.com')

    personalization = SendGrid::Personalization.new
    personalization.add_to(SendGrid::Email.new(email: user.email))
    reset_password_url = edit_password_reset_url(user)
    personalization.add_dynamic_template_data({
                                                'email' => user.email,
                                                'reset_password_url' => reset_password_url
                                              })

    mail.add_personalization(personalization)
    mail.template_id = 'd-fcf9735f1f7d4488ba3d15b95305fb96'

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    if response.status_code.to_i == 202
      puts 'Password reset instructions email sent successfully'
    else
      puts 'Failed to send password reset instructions email'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def edit_password_reset_url(user)
    "#{ENV['GYM_GENIUS_URL']}/login/reset?reset_password_token=#{user.reset_password_token}&email=#{user.email}"
  end
end
