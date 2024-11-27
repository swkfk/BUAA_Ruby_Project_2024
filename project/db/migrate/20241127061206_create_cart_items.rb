class CreateCartItems < ActiveRecord::Migration[7.2]
  def change
    create_table :cart_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :good, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
