class Category < ActiveRecord::Base
  has_many :product_categories
  has_many :products, through: :product_categories#, foreign_key: :product_id
  #accepts_nested_attributes_for :products, :allow_destroy => true, :reject_if => :all_blank
  validates :name, uniqueness: true
  #DO NOT VALIDATE NAME PRESENCE TRUE!
end
