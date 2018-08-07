class CreateCouples < ActiveRecord::Migration[5.1]
  def change
    create_table :couples do |t|
      t.integer :husband_id
      t.integer :wife_id
      t.datetime :created_at
    end
  end
end
