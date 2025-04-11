json.extract! comment, :id, :user_id, :rating_id, :content, :likes_count, :created_at, :updated_at
json.url comment_url(comment, format: :json)
