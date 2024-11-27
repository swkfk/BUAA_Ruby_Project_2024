json.extract! comment, :id, :user_id, :good_id, :content, :score, :created_at, :updated_at
json.url comment_url(comment, format: :json)
