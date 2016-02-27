class Post < ActiveRecord::Base
  has_many :comments, :inverse_of => :post
  belongs_to :user, :inverse_of => :posts
end
