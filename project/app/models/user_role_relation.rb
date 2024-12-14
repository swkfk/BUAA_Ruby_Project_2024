class UserRoleRelation < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :user_role, class_name: "UserRole", foreign_key: "user_role_id"
end
