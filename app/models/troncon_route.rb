class TronconRoute < ActiveRecord::Base
  include Featurable
  featurable :geometry, [:num_route]

  belongs_to :point_repere_init, :class_name => "PointRepere"
  belongs_to :point_repere_final, :class_name => "PointRepere"
  belongs_to :route
  has_many :works

  validates :vocation, presence:true
  validates :nb_chausse, presence:true
  validates :nb_voies, presence:true
  validates :etat, presence:true
  validates :acces, presence:true
  validates :res_vert, presence:true
  validates :sens, presence:true
  VALID_NUM_REGEX = /\A[AND].+\z/i
  validates :num_route, presence: true, length: { maximum: 50 },
            format: { with: VALID_NUM_REGEX }
  validates :class_adm, presence:true
  validates :longueur, presence:true

end
