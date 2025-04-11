class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :rating
  
  validates :content, presence: true
end
