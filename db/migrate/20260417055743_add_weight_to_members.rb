class AddWeightToMembers < ActiveRecord::Migration[8.1]
  def change
    add_column :members, :weight, :decimal, null: false, default: 1
  end
end
