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
            title: Faker::Company.name,
            owner_name: [Faker::Name.name, Faker::Name.name].join(' '),
            owner_phone: Faker::PhoneNumber.cell_phone
          }
        } 
      )
    end
  end
  
  def send_request_to_arrow_pass
    options = {
      event_id: event.id, 
      purchase: {
        name: name, 
        email: email,
        identifier: Time.now.to_i
      }, 
      purchased_tickets: tickets.map do |ticket|
        {
          number: ticket.number,
          options: {
            title: ticket.options["title"],
            owner_name: ticket.options["owner_name"],
            owner_phone: ticket.options["owner_phone"]
          }  
        }
      end
    }
    
    resource = RestClient::Resource.new(
        Settings.arrow_pass_host,
        headers: {
          "APS-CLIENT" => Settings.client.app_key,
          "SIGN-CODE" => options.sign(Settings.client.app_secret)
        }
      )
      
    response = resource["/api/ts/events/#{event.id}/purchases.json"].post(
                               URI.unescape(options.to_param)
                              )
  end  
end
