module Pattana
  module Api
    module V1
      class CountriesController < BaseController

        def index
          proc_code = Proc.new do
            @countries = Country.where("show_in_api is true").all
            @success = true
            @data = @countries
          end
          render_json_response(proc_code)
        end
      end
    end
  end
end

