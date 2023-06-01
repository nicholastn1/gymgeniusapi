# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    super.merge('foo' => 'bar')
  end

  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!
  end

  def reset_password!(password)
    self.password = password
    save!
  end

  def reset_password_token_valid?
    reset_password_sent_at && reset_password_sent_at > 2.hours.ago
  end

  attribute :reset_password_token, :string
  attribute :reset_password_sent_at, :datetime
end
