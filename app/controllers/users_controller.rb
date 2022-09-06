class UsersController < ApplicationController
  before_action :authorized, except: [:create, :login]

  def create
    @user = User.create(user_params)
    raise 'Invalid user' unless @user.valid?
    token = encode_token(SecureRandom.urlsafe_base64(nil, false))
    UsersToken.create(user_id: @user.id, token: token)
    render json: { user: @user, token: token }
  rescue StandardError => e
    errors_msg = @user&.errors
    errors_msg ||= e

    render json: { error: errors_msg }
  end

  def login
    @user = User.find_by(email: params[:email])
    raise 'Invalid email or password' unless @user && @user&.authenticate(params[:password])
    token = encode_token(SecureRandom.urlsafe_base64(nil, false))
    UsersToken.create(user_id: @user.id, token: token)
    render json: { name: @user.name, token: token, expiration: 8.hours.from_now }
  rescue StandardError => e
    render json: { error: e }
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
