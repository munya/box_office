class Purchase < ActiveRecord::Base
  belongs_to :event
  
  after_create :send_request_to_arrow_pass
  
  private
  
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
                                 purchased_tickets: [
                                   {
                                   number: 'ticket1',
                                   options: {
                                     raw: 10, 
                                     seat: 20
                                     }
                                   },
                                   {
                                   number: 'ticket2',
                                   options: {
                                     raw: 10, 
                                     seat: 21
                                     }
                                   },
                                 ]
                               }.to_param)
                              )
  end  
end
