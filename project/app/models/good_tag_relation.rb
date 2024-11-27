class GoodTagRelation < ApplicationRecord
  belongs_to :good, class_name: "Good", foreign_key: "good_id"
  belongs_to :attr_tag, class_name: "AttrTag", foreign_key: "attr_tag_id"
end
