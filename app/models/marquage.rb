class Marquage < ActiveRecord::Base
  actable
  belongs_to :work
  has_many :produits

  #acts_as_predecessor
end
