class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :event_id
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
