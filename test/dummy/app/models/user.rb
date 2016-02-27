class User < ActiveRecord::Base
  has_many :comments, :inverse_of => :user
  has_many :posts, :inverse_of => :user
end
