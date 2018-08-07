class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :digest, limit: 500
      t.string :gender, limit: 1
      t.string :email
      t.string :tel, limit: 20
      t.datetime :born_date
      t.timestamps
    end
  end
end
