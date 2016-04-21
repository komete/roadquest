class AppelOffre < ActiveRecord::Base
  mount_uploader :document_annexe, DocumentAnnexeUploader
  belongs_to :entrepreneur

  validates :budget, presence: true
  validates :periode, presence: true
  validates :document_annexe, presence: true

  def is_now_assigned(id)
    update_attribute(:entrepreneur_id, id)
    update_attribute(:assigned, true)
  end
end
