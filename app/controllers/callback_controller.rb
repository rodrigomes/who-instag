class CallbackController < ApplicationController

  def callback
    response = Instagram.get_access_token(params[:code],
    	:redirect_uri => 'http://localhost:3000/callback')
    session[:access_token] = response.access_token

    # update user info with instagram user data

    client = Instagram.client(:access_token => session[:access_token])
    instag_user = client.user

    @user = current_user
    @user.username = instag_user.username
    @user.profile_name = instag_user.full_name
    @user.access_token = session[:access_token]
    @user.profile_picture = instag_user.profile_picture
    @user.save!

    redirect_to users_path
  end

  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => 'http://localhost:3000/callback')
  end
end
