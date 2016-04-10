class TronconRoutesController < ApplicationController
  all_application_helpers

  before_action :logged_user, only: [:show]
  before_action :set_troncon_route, only: [:show, :show_travaux]

  def select

  end

  def import
    #@shpfile = "/home/remi/shapes/" + params[:file]
    @shpfile = "/Users/remiguillaume/Downloads/" + params[:file]

    factory = RGeo::Geographic.spherical_factory(:srid => 4326)
    RGeo::Shapefile::Reader.open(@shpfile, :factory => factory) do |file|
      file.each do |record|
        # 1: Vérification de la route
        num = record['NUM_ROUTE']

        if Route.exists?(num_route: num)
          @route = Route.find_by_num_route(num)
        else
          @route = Route.new(:num_route => num)
          @route.save
        end

        @troncon_route = TronconRoute.new(:vocation=>Iconv.conv('UTF-8', 'iso8859-1', record["VOCATION"]),:nb_chausse=>Iconv.conv('UTF-8', 'iso8859-1', record["NB_CHAUSSE"]),
                                          :nb_voies=>Iconv.conv('UTF-8', 'iso8859-1', record["NB_VOIES"]),:etat=>Iconv.conv('UTF-8', 'iso8859-1', record["ETAT"]),
                                          :acces=>Iconv.conv('UTF-8', 'iso8859-1', record["ACCES"]),:res_vert=>Iconv.conv('UTF-8', 'iso8859-1', record["RES_VERT"]),
                                          :sens=>Iconv.conv('UTF-8', 'iso8859-1', record["SENS"]),:res_europe=>Iconv.conv('UTF-8', 'iso8859-1', record["RES_EUROPE"]),
                                          :num_route=>Iconv.conv('UTF-8', 'iso8859-1', record["NUM_ROUTE"]),
                                          :class_adm=>Iconv.conv('UTF-8', 'iso8859-1', record["CLASS_ADM"]),:longueur=>record["LONGUEUR"],:route_id=>@route.id, :geometry => record.geometry)
        @troncon_route.save
      end
      file.rewind
      record = file.next
    end
    flash[:success] = "Données importées avec succès"
    redirect_to troncon_routes_path
  end

  def index
    @troncon_routes = TronconRoute.all
    respond_to do |format|
      format.html
      format.json do
        feature_collection = TronconRoute.to_feature_collection @troncon_routes
        render json: RGeo::GeoJSON.encode(feature_collection)
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "troncon_route_" + @troncon_route.id.to_s, encoding: "UTF-8"
      end
    end
  end

  def show_travaux

  end

  :private

  def set_troncon_route
    @troncon_route = TronconRoute.find(params[:id])
  end
end
