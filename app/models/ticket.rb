class Ticket < ActiveRecord::Base
  belongs_to :purchase
end
