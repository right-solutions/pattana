module Pattana
  module Api
    module V1
      class RegionsController < BaseController

        def index
          proc_code = Proc.new do
            @country = Country.find_by_id(params[:country_id])
            if @country
              @regions = @country.regions.where("show_in_api is true").order("name ASC").all
              @success = true
              @data = @regions
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.regions.country_not_found.heading"),
                message: I18n.translate("api.regions.country_not_found.message")
              }
            end
          end
          render_json_response(proc_code)
        end
      end
    end
  end
end

