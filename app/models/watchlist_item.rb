class WatchlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  
  validates :user_id, uniqueness: { scope: :movie_id, message: "This movie is already in your watchlist" }
end