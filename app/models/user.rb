class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable,
  # :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :profile_name, :username

  has_many :followers

  def has_follower(user, follower)
  	@user = User.find_by_username(user.username)
  	friend_exists = 0;
  	@user.followers.each do |f|
      if follower.username == f.username then
        friend_exists = friend_exists + 1
      end
    end
    return friend_exists
  end

end
