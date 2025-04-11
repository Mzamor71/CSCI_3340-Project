class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable   
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :watchlist_items, dependent: :destroy
  has_many :watchlist_movies, through: :watchlist_items, source: :movie
end