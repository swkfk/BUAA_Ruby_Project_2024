class OrderItem < ApplicationRecord
  belongs_to :good
  belongs_to :order
end
