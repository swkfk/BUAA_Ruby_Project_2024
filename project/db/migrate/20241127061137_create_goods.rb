class CreateGoods < ActiveRecord::Migration[7.2]
  def change
    create_table :goods do |t|
      t.string :name
      t.string :description
      t.decimal :price, precision: 8, scale: 2
      t.string :image

      t.timestamps
    end
  end
end
