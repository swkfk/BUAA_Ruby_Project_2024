class Good < ApplicationRecord
  has_and_belongs_to_many :images
  has_many :good_tag_relations, dependent: :destroy
  has_many :good_color_relations, dependent: :destroy
  has_many :favorite_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :comments, dependent: :destroy
end
