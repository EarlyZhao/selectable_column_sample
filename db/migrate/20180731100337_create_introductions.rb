class CreateIntroductions < ActiveRecord::Migration[5.1]
  def change
    create_table :introductions do |t|
      t.integer :user_id
      t.text :description
      t.string :digest
      t.timestamps
    end
  end
end
