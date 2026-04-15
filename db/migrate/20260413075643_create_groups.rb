class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :total_amount, default: 0, null: false

      t.timestamps
    end
  end
end
