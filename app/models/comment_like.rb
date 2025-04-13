class CommentLike < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  
  # Ensure uniqueness
  validates :user_id, uniqueness: { scope: :comment_id, message: "can only like a comment once" }
end