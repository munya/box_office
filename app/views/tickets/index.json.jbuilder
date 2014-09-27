json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :number, :purchase_id, :options
  json.url ticket_url(ticket, format: :json)
end
