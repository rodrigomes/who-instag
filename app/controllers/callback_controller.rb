class CallbackController < ApplicationController

  before_filter :authenticate_user!

  def callback
    response = Instagram.get_access_token(params[:code],
    	:redirect_uri => 'http://who-instag.herokuapp.com/callback')
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
    redirect_to Instagram.authorize_url(:redirect_uri => 'http://who-instag.herokuapp.com/callback')
  end

  def followers
    #follower loop
    client = Instagram.client(:access_token => session[:access_token])
    @user = current_user
    client.user_followed_by.each do |follower|
      #check if user has a follower
      if @user.has_follower(@user, follower) > 0 then
        @friend = @user.followers.find_by_username(follower.username)
        # set follower as a regular friend and update the last_change
        @friend.state = "friend"
        @friend.last_change = Time.now
        @friend.save!
      else
        # save new friend in followers list
        @user.followers.create(username: follower.username)
        @friend = @user.followers.find_by_username(follower.username)
        @friend.state = "new friend"
        @friend.last_change = Time.now
        @friend.save!
      end
    end

    # find unfollowed
    @user.followers.each do |follower|
      if follower.last_change == nil then
        @friend = @user.followers.find_by_username(follower.username)
        @friend.state = "unfollowed"
        @friend.save!
      elsif follower.last_change < 30.seconds.ago then
        @friend = @user.followers.find_by_username(follower.username)
        @friend.state = "unfollowed"
        @friend.save!
      end
    end

    redirect_to user_path(current_user)
  end
end
