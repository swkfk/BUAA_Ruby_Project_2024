class GoodColorRelation < ApplicationRecord
  belongs_to :good, class_name: "Good", foreign_key: "good_id"
  belongs_to :color, class_name: "AttrColor", foreign_key: "attr_color_id"
end
