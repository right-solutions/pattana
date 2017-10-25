module Pattana
  module Api
    module V1
      class DocsController < Pattana::ApplicationController

        layout 'kuppayam/docs'

        before_action :set_nav_items, :set_tab_items
        helper_method :breadcrumb_home_path

        def countries
          set_title("Countries API")
          @request_type = "GET"
          @end_point = "/api/v1/countries"
          @description = <<-eos
          This API will return all the countries with other details like dialing prefix and ISO codes. <br>
          This API can also be used to search countries by passing a query parameter 'q'.<br>
          eos

          @info = "It will return only those countries who has show_in_api set true"

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "pos_case_3", "pos_case_4"]

          set_nav("docs/pattana/countries")

          render 'kuppayam/api/docs/show'
        end

        def regions
          set_title("Regions API")
          @request_type = "GET"
          @end_point = "/api/v1/:country_id/regions"
          @description = <<-eos
          This API will return all the regions in a particular country. <br>
          The Country ID has to be passed. <br>
          This API can also be used to search regions by passing a query parameter 'q'.
          eos

          @info = "It will return only those regions who has show_in_api set true"

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            country_id: { mandatory: true, description: "The Country ID. You will get it from the Countries API", example: "for e.g: Country Id for U.A.E is 235 and that of India is 100", default: "" }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "pos_case_3", "pos_case_4", "neg_case_1"]

          set_nav("docs/pattana/regions")

          render 'kuppayam/api/docs/show'
        end

        def cities_in_a_country
          set_title("Cities API (in a country)")
          @request_type = "GET"
          @end_point = "/api/v1/countries/:country_id/cities"
          @description = ""
          @description = <<-eos
          This API will return all the cities in a particular country. <br>
          The Country ID has to be passed. <br>
          This API can also be used to search cities in a country by passing a query parameter 'q'.
          eos

          @info = "It will return only those cities who has show_in_api set true"

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            country_id: { mandatory: true, description: "The Country ID. You will get it from the Countries API", example: "for e.g: Country Id for U.A.E is 235 and that of India is 100", default: "" }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "pos_case_3", "pos_case_4", "neg_case_1"]

          set_nav("docs/pattana/cities_in_a_country")

          render 'kuppayam/api/docs/show'
        end

        def cities_in_a_region
          set_title("Cities API (in a region)")
          @request_type = "GET"
          @end_point = "/api/v1/regions/:region_id/cities"
          @description = <<-eos
          This API will return all the cities in a particular region. <br>
          The Region ID has to be passed. <br>
          This API can also be used to search cities in a region by passing a query parameter 'q'.
          eos

          @info = "It will return only those cities who has show_in_api set true"
          
          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            country_id: { mandatory: true, description: "The Country ID. You will get it from the Countries API", example: "for e.g: Country Id for U.A.E is 235 and that of India is 100", default: "" },
            region_id: { mandatory: true, description: "The Region ID. You will get it from the Regions API", example: "for e.g: Country Id for India is 100 and Region ID for Kerala is 1314", default: "" }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "pos_case_3", "pos_case_4", "neg_case_1"]

          set_nav("docs/pattana/cities_in_a_region")

          render 'kuppayam/api/docs/show'
        end

        private

        def set_nav_items
          @nav_items = {
            countries: { nav_class: "docs/pattana/countries", icon_class: "fa-flag-checkered", url: pattana.docs_api_v1_countries_path, text: "Countries API"},
            regions: { nav_class: "docs/pattana/regions", icon_class: "fa-globe", url: pattana.docs_api_v1_regions_path, text: "Countries API"},
            cities_in_a_country: { nav_class: "docs/pattana/cities_in_a_country", icon_class: "fa-map-marker", url: pattana.docs_api_v1_cities_in_a_country_path, text: "Cities (in a Country)"},
            cities_in_a_region: { nav_class: "docs/pattana/cities_in_a_region", icon_class: "fa-map-marker", url: pattana.docs_api_v1_cities_in_a_region_path, text: "Cities (in a Region)"}
          }
        end

        def set_tab_items
          @tab_items = {
            pattana: { nav_class: "docs/pattana", icon_class: "fa-globe", url: pattana.docs_api_v1_countries_path, text: "Location APIs"}
          }
        end

        def breadcrumb_home_path
          pattana.dashboard_path
        end

        def breadcrumbs_configuration
          {
            heading: "Pattana - API Documentation",
            description: "A brief documentation of all APIs implemented in the gem Pattana with input and output details and examples",
            links: []
          }
        end

      end
    end
  end
end
