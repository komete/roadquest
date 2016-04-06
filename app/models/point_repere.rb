class PointRepere < ActiveRecord::Base
  has_many :pr_init, :class_name => "TronconRoute", :foreign_key => "point_repere_init_id"
  has_many :pr_final, :class_name => "TronconRoute", :foreign_key => "point_repere_final_id"

  #geocoded_by :latitude,:longitude
  #after_validation :geocode

  validates :latitude , presence:true
  validates :longitude , presence:true
  VALID_PROJECTION_REGEX = /\AESPG:[0-9]{4}\z/i
  validates :projection , presence:true, format: {with: VALID_PROJECTION_REGEX}
end
