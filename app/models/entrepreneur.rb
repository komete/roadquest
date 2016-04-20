class Entrepreneur < ActiveRecord::Base
  acts_as :user, as: :utilisateur
  has_many :appel_offres
end
