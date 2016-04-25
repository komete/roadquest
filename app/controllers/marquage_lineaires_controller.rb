class MarquageLineairesController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:show]
  before_action :set_marquage, only: [:show]

  def show
  end

  :private

  def set_marquage
    @marquage = MarquageLineaire.find(params[:id])
    @m = Marquage.find_by actable_id: (params[:id]), actable_type: 'MarquageLineaire'
    id = @m.work_id
    @work = Work.find(id)
  end
end
