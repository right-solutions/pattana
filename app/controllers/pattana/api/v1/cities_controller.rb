module Pattana
  module Api
    module V1
      class CitiesController < BaseController

        def cities_in_a_country
          proc_code = Proc.new do
            @country = Country.find_by_id(params[:country_id])
            if @country
              @cities = @country.cities.where("show_in_api is true").all
              @success = true
              @data = @cities
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.cities.country_not_found.heading"),
                message: I18n.translate("api.cities.country_not_found.message")
              }
            end
          end
          render_json_response(proc_code)
        end

        def cities_in_a_region
          proc_code = Proc.new do
            @region = Region.find_by_id(params[:region_id])
            if @region
              @cities = @region.cities.where("show_in_api is true").all
              @success = true
              @data = @cities
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.cities.region_not_found.heading"),
                message: I18n.translate("api.cities.region_not_found.message")
              }
            end
          end
          render_json_response(proc_code)
        end
      end
    end
  end
end

