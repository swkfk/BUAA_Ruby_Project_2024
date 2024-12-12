class CreateGoodsImagesJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :goods, :images do |t|
      t.index :good_id
      t.index :image_id
    end
  end
end
