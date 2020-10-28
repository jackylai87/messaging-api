class ConversationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :set_conversation, only: [:show, :update]
  # before_action :only_logged_in, :set_user
  
  def index
    @conversations = Conversation.includes(:messages).where(status: params[:status] || 'open')
    render json: @conversations, status: :ok
  end

  def show
    render json: {conversation: @conversation, messages: @conversation.messages}, status: :ok
  end

  def update
    begin
      @conversation.update!(status: conversation_params[:status])
      render json: {message: 'Successfully updated conversation status'}, status: :ok
    rescue ActiveRecord::RecordInvalid, ArgumentError
      render json: {message: 'Unable to update conversation'}, status: :bad_request
    end
  end

  private
  def set_conversation
    @conversation = Conversation.includes(:messages).find(params[:id])
  end

  def not_found
    render json: {message: 'Resource not found'}, status: :not_found
  end

  def conversation_params
    params.require(:conversation).permit(:status)
  end

  def only_logged_in
    if session[:user].nil?
      render json: {message: 'Unauthorized Request'}, status: :unauthorized
    end
  end

  def set_user
    @user = User.find(session[:user])
  end
end
