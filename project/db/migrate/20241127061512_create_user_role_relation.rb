class CreateUserRoleRelation < ActiveRecord::Migration[7.2]
  def change
    create_table :user_role_relations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :user_role, null: false, foreign_key: true
      t.timestamps
    end
  end
end
