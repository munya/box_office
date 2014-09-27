class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :number
      t.integer :purchase_id
      t.hstore :options

      t.timestamps
    end
  end
end
