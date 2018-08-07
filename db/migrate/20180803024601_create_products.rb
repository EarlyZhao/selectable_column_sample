class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.integer :organization_id
      t.string :name
      t.integer :price
      t.string :introduction
      t.timestamps
    end
  end
end
