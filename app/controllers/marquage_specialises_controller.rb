class MarquageSpecialisesController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:show]
  before_action :set_marquage, only: [:show]

  def show
  end

  :private

  def set_marquage
    @marquage = MarquageSpecialise.find(params[:id])
    id = Marquage.find(params[:id]).work_id
    @m = Marquage.find(params[:id])
    @work = Work.find(id)
  end
end
