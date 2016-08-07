class SessionsController < ApplicationController
  include Authenticator
  public_endpoint

  def new
    if current_user
      redirect_to root_path
      return
    end
    @error_message = flash[:error]
    @provider = OAuthProvider.github
    unless @provider
      redirect_to install_oauth_path
      return
    end
  end

  def create
    email = params[:email]
    user = User.authenticate!(email, params[:password])
    unless user
      logger.info "#{email} did not match any known users"
      flash[:username] = email
      flash[:error] = :no_match
      redirect_to action: :new
      return
    end

    url = session[:return_url] || root_path
    assume_user(user)
    redirect_to url
  end

  def destroy
    session.destroy
    reset_session
    redirect_to new_user_session_path
  end
end
