class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.string :name, null: false, default: ""
      t.references :group, null: false, foreign_key: true
      t.decimal :weight, null: false, default: 1

      t.timestamps
    end
  end
end
