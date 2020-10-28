class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
    
    if user
      session[:user] = user.id
      render json: {message: 'Successfully logged in'}, status: :created
    else
      render json: {message: 'Failed to logged in'}, status: :bad_request
    end
  end

  def destroy
    session[:user] = nil
    render json: {message: 'Successfully logged out'}, status: :ok
  end
end
