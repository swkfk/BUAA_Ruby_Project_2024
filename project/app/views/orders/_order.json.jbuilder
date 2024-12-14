json.extract! order, :id, :user_id, :name, :address, :phone, :created_at, :updated_at
json.url order_url(order, format: :json)
