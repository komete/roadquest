class MarquagesController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:show]
  before_action :set_marquage, only: [:show]

  def index
    @marquages_lineaires = MarquageLineaire.all
    @marquages_specialises = MarquageSpecialise.all
  end

  def show

  end

  def new
    @id = params[:id]
    @marquage = Marquage.new
  end

  def create

    if params[:marquage][:type_marquage]== "specialises"
      flash[:success] = "Marquage créé"
      @marquage = MarquageSpecialise.create(:type_marquage => params[:marquage][:type_marquage], :couleur => params[:marquage][:couleur],
                                            :type_travaux => params[:marquage_specialise][:type_travaux], :dimension =>  params[:marquage_specialise][:dimension], :work_id => params[:work_id] )
      redirect_to controller: "marquage_specialises", action: "show", id: @marquage.id
    else
      flash[:success] = "Marquage créé"
      @marquage = MarquageLineaire.create(:type_marquage => params[:marquage][:type_marquage], :couleur => params[:marquage][:couleur],
                                          :largeur_bande => params[:marquage_lineaire][:largeur_bande], :work_id => params[:work_id] )
      redirect_to controller: "marquage_lineaires", action: "show", id: @marquage.id

    end
  end

  :private

  def set_marquage
    @marquage = Marquage.find(params[:id])
  end

end
