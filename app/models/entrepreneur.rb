class Entrepreneur < ActiveRecord::Base
  acts_as :user, as: :utilisateur
end
