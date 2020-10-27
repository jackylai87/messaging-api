class Twilio::MessagesController < ApplicationController
  def create
    message = Message.new(
      to: params[:To],
      from: params[:From],
      body: params[:Body],
      twilio_response: params.as_json
    )

    begin
      message.save!
      render json: {message: 'Successfully create message'}, status: :created
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordInvalid
      render json: {message: 'Unable to create message', error: ''}, status: :bad_request
    end
  end
end
