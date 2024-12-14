class User < ApplicationRecord
  has_many :user_role_relations
  has_many :user_roles, through: :user_role_relations
end
