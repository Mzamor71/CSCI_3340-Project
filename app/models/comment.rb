class Comment < ApplicationRecord
  # Existing associations
  belongs_to :user
  belongs_to :rating
  
  # New associations
  has_many :comment_likes, dependent: :destroy
  has_many :liking_users, through: :comment_likes, source: :user
  
  # Helper method to get the total likes count
  def likes_count
    comment_likes.count
  end
  
  # Helper method to check if a user liked this comment
  def liked_by?(user)
    return false unless user
    comment_likes.exists?(user_id: user.id)
  end
end