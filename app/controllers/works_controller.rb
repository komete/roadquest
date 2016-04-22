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

        #  Factory
        lamber_proj4 = '+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs '
        lambert_wkt = <<WKT
        PROJCS["RGF93 / Lambert-93",
GEOGCS["RGF93",
DATUM["Reseau_Geodesique_Francais_1993",
SPHEROID["GRS 1980",6378137,298.257222101,AUTHORITY["EPSG","7019"]],
TOWGS84[0,0,0,0,0,0,0],
AUTHORITY["EPSG","6171"]],
PRIMEM["Greenwich",0,
AUTHORITY["EPSG","8901"]],
UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],
AUTHORITY["EPSG","4171"]],UNIT["metre",1,
AUTHORITY["EPSG","9001"]],
PROJECTION["Lambert_Conformal_Conic_2SP"],
PARAMETER["standard_parallel_1",49],
PARAMETER["standard_parallel_2",44],
PARAMETER["latitude_of_origin",46.5],
PARAMETER["central_meridian",3],
PARAMETER["false_easting",700000],
PARAMETER["false_northing",6600000],
AUTHORITY["EPSG","2154"],
AXIS["X",EAST],AXIS["Y",NORTH]]

WKT
        wgs84_proj4 = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
        wgs84_wkt = <<WKT
  GEOGCS["WGS 84",
    DATUM["WGS_1984",
      SPHEROID["WGS 84",6378137,298.257223563,
        AUTHORITY["EPSG","7030"]],
      AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0,
      AUTHORITY["EPSG","8901"]],
    UNIT["degree",0.01745329251994328,
      AUTHORITY["EPSG","9122"]],
    AUTHORITY["EPSG","4326"]]
WKT
        wgs84_factory = RGeo::Geographic.spherical_factory(:srid => 4326,
                                                           :proj4 => wgs84_proj4, :coord_sys => wgs84_wkt)
        lambert_factory = RGeo::Cartesian.factory(:srid => 2154,
                                                             :proj4 => lamber_proj4, :coord_sys => lambert_wkt)

        # TESTS
        point1_lambert = lambert_factory.point(6790483.2, 557108.1)
        point1_wgs84 = RGeo::Feature.cast(point1_lambert,
                                          :factory => wgs84_factory, :project => true)
        #p point1_wgs84
        point2_wgs84 = wgs84_factory.point(48.373694, 2.013563)
        point2_lambert = RGeo::Feature.cast(point2_wgs84,
                                            :factory => lambert_factory, :project => true)
        lat, lng = 2.013563, 48.373694
        f = RGeo::Geographic.projected_factory(:projection_proj4 => lamber_proj4, :projection_srid => 2154)
        p f.parse_wkt("POINT (#{lng} #{lat})").projection
        p point2_lambert
        @works.each do |w|
          old_point = w.lonlat
          new_point = RGeo::Feature.cast(old_point,
                                         :factory => lambert_factory, :project => true)
          w.lonlat = new_point
          p w.lonlat
        end
        feature_collection = Work.to_feature_collection @works
        #File.open('public/geojson/works.geojson', 'w') {|file| file.write RGeo::GeoJSON.encode(feature_collection).to_json}
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

    wgs84_proj4 = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
    wgs84_wkt = <<WKT
  GEOGCS["WGS 84",
    DATUM["WGS_1984",
      SPHEROID["WGS 84",6378137,298.257223563,
        AUTHORITY["EPSG","7030"]],
      AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0,
      AUTHORITY["EPSG","8901"]],
    UNIT["degree",0.01745329251994328,
      AUTHORITY["EPSG","9122"]],
    AUTHORITY["EPSG","4326"]]
WKT
    wgs84_factory = RGeo::Geographic.spherical_factory(:srid => 4326,
                                                       :proj4 => wgs84_proj4, :coord_sys => wgs84_wkt)

    @work = Work.find(params[:id])
    @troncon = TronconRoute.find(@work.troncon_route_id)
    factory = wgs84_factory
    point = factory.point(params[:lon],params[:lat])
    @work.to_geolocate(point)
    flash[:success] = "Géolocalisation terminée"
    redirect_to controller: 'troncon_routes', action: 'show_travaux', id: @troncon
  end

  :private

    def set_work
      @work = Work.find(params[:id])
    end

    def work_params
      params.require(:work).permit(:type_work, :description, :debut, :fin, :intervenant)
    end
end
