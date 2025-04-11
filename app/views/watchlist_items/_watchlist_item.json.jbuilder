json.extract! watchlist_item, :id, :user_id, :movie_id, :created_at, :updated_at
json.url watchlist_item_url(watchlist_item, format: :json)
