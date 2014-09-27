class AddTotalTicketsToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :total_tickets, :integer
  end
end
