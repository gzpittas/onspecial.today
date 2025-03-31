json.extract! item, :id, :name, :description, :credit_price, :cash_price, :created_at, :updated_at
json.url item_url(item, format: :json)
