class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :good, null: false, foreign_key: true
      t.string :content
      t.integer :score

      t.timestamps
    end
  end
end
