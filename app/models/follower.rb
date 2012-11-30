class Follower < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :username

  attr_accessible :username, :state, :last_change

end
