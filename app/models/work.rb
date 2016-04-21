class Work < ActiveRecord::Base
  include Featurable
  featurable :lonlat, [:type_work, :description, :intervenant]

  belongs_to :troncon_route
  has_many :marquages

  validates :type_work, presence:true
  validates :description, presence:true
  validates :intervenant, presence:true

  def to_geolocate(point)
    update_attribute(:lonlat, point)
  end
end
