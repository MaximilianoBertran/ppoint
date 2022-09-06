class User < ApplicationRecord
  has_secure_password
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP },
                    presence: true,
                    uniqueness: true
  validates :name, presence: true
  validates :password_digest, presence: true

  has_many :product
  has_many :user_token
end
