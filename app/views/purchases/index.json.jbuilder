json.array!(@purchases) do |purchase|
  json.extract! purchase, :id, :event_id, :email, :name
  json.url purchase_url(purchase, format: :json)
end
