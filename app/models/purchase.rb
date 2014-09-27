class Purchase < ActiveRecord::Base
  belongs_to :event
  has_many :tickets
  
  before_create :setup_tickets
  after_create :send_request_to_arrow_pass
  
  attr_accessor :total_tickets
  
  private
  
  def setup_tickets
    (0..(total_tickets.to_i-1)).each do |n|
      tickets.build(
        {
          number: "#{Settings.client.app_key} - #{SecureRandom.hex(8)}",
          options: {
            raw: rand(40), 
            seat: rand(60)
            }
        } 
      )
    end
  end
  
  def send_request_to_arrow_pass
    resource = RestClient::Resource.new(
        Settings.arrow_pass_host,
        headers: {
          "APS-CLIENT" => Settings.client.app_key
        }
      )
      
    response = resource["/api/ts/events/#{event.id}/purchases.json"].post(
                               URI.unescape({
                                 purchase: {
                                   name: name, 
                                   email: email
                                   }, 
                                 purchased_tickets: tickets.map do |ticket|
                                   {
                                     number: ticket.number,
                                     options: ticket.options
                                   }
                                 end
                               }.to_param)
                              )
  end  
end
