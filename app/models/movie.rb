class Movie < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :users, through: :ratings
  has_and_belongs_to_many :genres
  has_many :watchlist_items, dependent: :destroy
  has_many :watchlisting_users, through: :watchlist_items, source: :user
  validates :title, presence: true
  def average_rating
    return 0 if ratings.empty?
    (ratings.sum(:stars) / ratings.count.to_f).round(1)
  end
end

