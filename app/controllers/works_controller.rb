class WorksController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:edit, :update, :show]
  before_action :logged_admin, only: [:new, :create, :destroy]
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  def index
    @works = Work.all
    respond_to do |format|
      format.html
      format.json do
        feature_collection = Work.to_feature_collection @works
        render json: RGeo::GeoJSON.encode(feature_collection)
      end
    end
  end

  def show
    @troncon = @work.troncon_route_id
  end

  def new
    @id = params[:id]
    @work = Work.new
  end


  def edit
  end

  def create
    @id = params[:troncon_id]
    if Entrepreneur.exists?(ref_entreprise: params[:work][:intervenant])
      date = params[:work]["debut(1i)"] + "-" +  params[:work]["debut(2i)"]  + "-" +  params[:work]["debut(3i)"]
      @work = Work.new( :type_work=>params[:work][:type_work],:description=>params[:work][:description],:debut=>date,:fin=>params[:work][:fin],
                      :intervenant=>params[:work][:intervenant], :troncon_route_id => @id)
      if @work.save
        flash[:success] = "Travail créé"
        redirect_to @work
      else
        redirect_to controller: "works", action: "new", id: params[:troncon_id].to_s
      end
    else
      flash[:danger] = "L'intervenant n'existe pas"
      redirect_to controller: "works", action: "new", id: params[:troncon_id].to_s
    end
  end


  def update
   @work.update(work_params)
   redirect_to @work
  end


  def destroy
    @work.destroy
  end

  def edit_geolocation
    @work = Work.find(params[:id])
  end

  def update_geolocation
    @work = Work.find(params[:id])
    @troncon = TronconRoute.find(@work.troncon_route_id)
    factory = RGeo::Geographic.spherical_factory#(:srid => 2154) #simple_mercator_factory#
    point = factory.point(params[:lon],params[:lat])
    @work.to_geolocate(point)
    flash[:success] = "Géolocalisation terminée"
    redirect_to controller: 'troncon_routes', action: 'show_travaux', id: @troncon
  end

  private

    def set_work
      @work = Work.find(params[:id])
    end

    def work_params
      params.require(:work).permit(:type_work, :description, :debut, :fin, :intervenant)
    end
end
