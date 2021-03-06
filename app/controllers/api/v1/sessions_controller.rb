class Api::V1::SessionsController < ApplicationController

  respond_to :json

  def create
    user_password = create_params[:password]
    user_email = create_params[:email]
    @user = user_email.present? && User.find_by(email: user_email)
    if @user && @user.valid_password?(user_password)
      sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render json: {user: @user, message: "login successfully"}, status: 200, location: [:api, @user]
    else
      render json: {  message: "Invalid email or password"}, status: 200
    end
  end

  def destroy
    @user = User.find_by auth_token: params[:id]
    @user.generate_authentication_token!
    @user.save
    head 204
  end

  private
  def create_params
    params.require(:session).permit :email, :password
  end
end
