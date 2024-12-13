class AttrTag < ApplicationRecord
  has_many :good_tag_relations, dependent: :destroy
end
