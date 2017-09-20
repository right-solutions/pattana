module Pattana
  module Api
    module V1
      class DocsController < Pattana::Api::V1::DocsBaseController

        layout 'kuppayam/docs'

        def countries
          set_title("Countries API")
          @request_type = "GET"
          @end_point = "/api/v1/countries"
          @description = "This API will return all the countries with other details like dialing prefix and ISO codes."

          @info = "It will return only those countries who has show_in_api set true"

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2"]

          set_nav("docs/countries")

          render 'kuppayam/api/docs/show'
        end

        def regions
          set_title("Regions API")
          @request_type = "GET"
          @end_point = "/api/v1/:country_id/regions"
          @description = "This API will return all the regions in a particular country. The Country ID has to be passed."

          @info = "It will return only those regions who has show_in_api set true"

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            country_id: { mandatory: true, description: "The Country ID. You will get it from the Countries API", example: "for e.g: Country Id for U.A.E is 235 and that of India is 100", default: "" }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "neg_case_1"]

          set_nav("docs/regions")

          render 'kuppayam/api/docs/show'
        end

        def cities_in_a_country
          set_title("Cities API (in a country)")
          @request_type = "GET"
          @end_point = "/api/v1/:country_id/cities"
          @description = "This API will return all the cities in a particular country. The Country ID has to be passed"

          @info = "It will return only those cities who has show_in_api set true"

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            country_id: { mandatory: true, description: "The Country ID. You will get it from the Countries API", example: "for e.g: Country Id for U.A.E is 235 and that of India is 100", default: "" }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "neg_case_1"]

          set_nav("docs/cities_in_a_country")

          render 'kuppayam/api/docs/show'
        end

        def cities_in_a_region
          set_title("Cities API (in a region)")
          @request_type = "GET"
          @end_point = "/api/v1/:country_id/:region_id/cities"
          @description = "This API will return all the cities in a particular region. The Country ID & Region ID has to be passed"

          @info = "It will return only those cities who has show_in_api set true"
          @warning = "Make sure that the region (id) belongs to the country (id). Use the countries and regions API to get real id"
          
          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            country_id: { mandatory: true, description: "The Country ID. You will get it from the Countries API", example: "for e.g: Country Id for U.A.E is 235 and that of India is 100", default: "" },
            region_id: { mandatory: true, description: "The Region ID. You will get it from the Regions API", example: "for e.g: Country Id for India is 100 and Region ID for Kerala is 1314", default: "" }
          }

          @example_path = "pattana/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/cities_in_a_region")

          render 'kuppayam/api/docs/show'
        end

      end
    end
  end
end
