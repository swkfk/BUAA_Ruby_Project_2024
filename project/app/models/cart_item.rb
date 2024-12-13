class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :good, dependent: :destroy
end
