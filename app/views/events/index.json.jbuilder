json.array!(@events) do |event|
  json.extract! event, :id, :identifier
  json.url event_url(event, format: :json)
end
