class CreateGenarations < ActiveRecord::Migration[5.1]
  def change
    create_table :generations do |t|
      t.integer :child_id
      t.integer :parent_id
      t.string :child_gender, limit: 1
      t.string :parent_gender, limit: 1
    end
  end
end
