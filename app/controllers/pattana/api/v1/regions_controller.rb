module Pattana
  module Api
    module V1
      class RegionsController < BaseController

        def index
          proc_code = Proc.new do
            @country = Country.find_by_id(params[:country_id])
            if @country
              @relation = @country.regions.includes(:country).where("regions.show_in_api is true").order("regions.name ASC")
              @relation = @relation.search(params[:q]) if params[:q]
              @relation = @relation.operational if params[:operational] && ["y","t","yes","true",1].include?(params[:operational].downcase)
              @regions = @relation.all
              @data = ActiveModelSerializers::SerializableResource.new(@regions, each_serializer: RegionPreviewSerializer)
              @success = true
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

