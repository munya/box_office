class Event < ActiveRecord::Base
  has_many :purchases
end
