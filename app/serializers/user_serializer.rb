# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :name, :image, :created_at

  attribute :created_date do |user|
    user.created_at&.strftime('%d/%m/%Y')
  end
end
