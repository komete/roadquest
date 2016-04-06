class Route < ActiveRecord::Base
  has_many :troncon_routes

  VALID_NUM_REGEX = /\A[AND].+\z/i
  validates :num_route, presence: true, length: { maximum: 50 },
            format: { with: VALID_NUM_REGEX }, uniqueness: {case_sensitive: true}
end
