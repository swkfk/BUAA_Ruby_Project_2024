class AddUserToImage < ActiveRecord::Migration[7.2]
  def change
    add_reference :images, :user, null: false, foreign_key: true
  end
end
