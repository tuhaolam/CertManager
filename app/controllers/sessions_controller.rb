class SessionsController < ApplicationController
  include Authenticator
  public_endpoint

  def new
    return redirect_to root_path if current_user

    @error_message = flash[:error]
    @provider = OAuthProvider.github

    redirect_to install_oauth_path unless @provider
  end

  def destroy
    session.destroy
    reset_session
    redirect_to new_user_session_path
  end
end
