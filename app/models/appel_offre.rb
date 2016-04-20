class AppelOffre < ActiveRecord::Base
  belongs_to :entrepreneur
  mount_uploader :document_annexe

  validates :budget, presence: true
  validates :periode, presence: true
  validates :document_annexe, presence: true
end
