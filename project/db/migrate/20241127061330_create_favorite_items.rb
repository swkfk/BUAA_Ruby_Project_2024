class CreateFavoriteItems < ActiveRecord::Migration[7.2]
  def change
    create_table :favorite_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :good, null: false, foreign_key: true

      t.timestamps
    end
  end
end
