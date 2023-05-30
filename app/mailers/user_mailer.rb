require 'sendgrid-ruby'
require 'dotenv/load'
include SendGrid

class UserMailer < ApplicationMailer
  def reset_password_instructions(user)
    from = SendGrid::Email.new(email: 'gymgeniusapi@gmail.com')
    to = SendGrid::Email.new(email: user.email)
    subject = 'Reset Password Instructions'
    reset_password_url = edit_password_reset_url(user)
    content = SendGrid::Content.new(type: 'text/plain', value: "Hi #{user.email},
        You have requested to reset your password.
        To do so, please click on the following link: #{reset_password_url}
        If you did not request to reset your password, please ignore this email.
        Thanks,
        GymGenius Team")
    mail = SendGrid::Mail.new(from, subject, to, content)

    # personalization = Personalization.new
    # personalization.add_to(Email.new(email: user.email))

    # mail.add_personalization(personalization)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    if response.status_code.to_i == 202
      puts 'Password reset instructions email sent successfully'
    else
      puts 'Failed to send password reset instructions email'
    end
  end

  private

  def edit_password_reset_url(user)
    "#{ENV['GYM_GENIUS_URL']}/login/reset?reset_password_token=#{user.reset_password_token}&email=#{user.email}"
  end
end