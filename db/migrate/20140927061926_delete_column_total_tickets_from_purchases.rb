class DeleteColumnTotalTicketsFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :total_tickets
  end
end
