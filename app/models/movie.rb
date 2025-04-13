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
  def youtube_embed_url
    return nil unless trailer_url.present?
    
    if trailer_url.include?("youtube.com") || trailer_url.include?("youtu.be")
      if trailer_url.include?("youtube.com/watch")
        video_id = trailer_url.split("v=").last.split("&").first
        "https://www.youtube.com/embed/#{video_id}"
      elsif trailer_url.include?("youtu.be")
        video_id = trailer_url.split("youtu.be/").last
        "https://www.youtube.com/embed/#{video_id}"
      else
        trailer_url # Return original if we can't parse it
      end
    else
      trailer_url # Non-YouTube URL
    end
  end
end

