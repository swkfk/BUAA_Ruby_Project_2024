class AttrColor < ApplicationRecord
  has_many :good_color_relations, dependent: :destroy
end
