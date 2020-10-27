class ConversationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  before_action :set_conversation, only: [:show, :update]
  
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
end
