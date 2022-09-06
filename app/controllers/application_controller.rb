class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    before_action :authorized, except: :show

    def auth_header
      request.headers['Authorization']
    end
  
    def encode_token(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  
    def decoded_token
      return unless auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, Rails.application.secrets.secret_key_base)
      rescue JWT::DecodeError
        nil
      end
    end
  
    def logged_in_user
      return unless auth_header
      user_token = UsersToken.find_by(token: auth_header.split(' ').last)
      return if !user_token || user_token.created_at < DateTime.now - 8.hours
      @user = User.find_by(id: user_token.user_id)
    end
  
    def logged_in?
      !!logged_in_user
    end
  
    def authorized
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end
end
