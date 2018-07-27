class OrderItem < ApplicationRecord
  validates_presence_of :order_id, :item_id, :quantity

  belongs_to :order
  belongs_to :item
end