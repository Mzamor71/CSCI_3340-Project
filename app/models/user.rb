class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable   
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :liked_comments, through: :comment_likes, source: :comment
  has_many :watchlist_items, dependent: :destroy
  has_many :watchlist_movies, through: :watchlist_items, source: :movie
  has_many :rated_movies, through: :ratings, source: :movie
end