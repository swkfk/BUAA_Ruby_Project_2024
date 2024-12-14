class FavoriteItem < ApplicationRecord
  belongs_to :user
  belongs_to :good
end
