class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :member, null: false, foreign_key: true, index: { unique: true }
      t.integer :amount, null: false, default: 0

      t.timestamps
    end
  end
end
