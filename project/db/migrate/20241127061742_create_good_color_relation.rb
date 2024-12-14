class CreateGoodColorRelation < ActiveRecord::Migration[7.2]
  def change
    create_table :good_color_relations do |t|
      t.references :good, null: false, foreign_key: true
      t.references :attr_color, null: false, foreign_key: true
      t.timestamps
    end
  end
end