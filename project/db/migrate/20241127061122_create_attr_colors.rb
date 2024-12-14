class CreateAttrColors < ActiveRecord::Migration[7.2]
  def change
    create_table :attr_colors do |t|
      t.string :rgb
      t.string :name

      t.timestamps
    end
  end
end
