class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :identifier

      t.timestamps
    end
  end
end
