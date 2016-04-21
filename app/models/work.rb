class Work < ActiveRecord::Base
  include Featurable
  featurable :geometry, [:type_work, :description, :intervenant]

  belongs_to :troncon_route
  has_many :marquages

  validates :type_work, presence:true
  validates :description, presence:true
  validates :intervenant, presence:true
end
