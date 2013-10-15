require 'user'

class SessionController < ApplicationController
  skip_before_filter :member_or_mentor
  
  def acquire_session
    respond_to do |format|
      format.json do
        session[:user] = User.fetch_from_token(params[:access_token])
        render json: { stat: :ok }
      end
    end
  end

  def logout
    session[:user] = nil
    redirect_to root_path
  end
end
