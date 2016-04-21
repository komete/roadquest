#
# Module source : https://climber2002.github.io/blog/2014/05/26/integrate-postgis-and-google-maps-in-rails-part-2/
#
module Featurable
  extend ActiveSupport::Concern

  module ClassMethods
    def featurable geom_attr_name, property_names = []
      define_method :to_feature do
        factory = RGeo::GeoJSON::EntityFactory.instance

        property_names = Array(property_names)
        properties = property_names.inject({}) do |hash, property_name|
          hash[property_name.to_sym] = read_attribute(property_name)
          hash
        end
        factory.feature read_attribute(geom_attr_name), self.id, properties
      end
    end

    def to_feature_collection models
      factory = RGeo::GeoJSON::EntityFactory.instance
      features = models.map(&:to_feature)
      factory.feature_collection features
    end
  end
end