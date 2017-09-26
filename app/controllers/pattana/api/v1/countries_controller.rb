module Pattana
  module Api
    module V1
      class CountriesController < BaseController

        def index
          proc_code = Proc.new do
            @relation = Country.show_in_api.order("countries.name ASC")
            @relation = @relation.search(params[:q]) if params[:q]
            @relation = @relation.operational if params[:operational] && ["y","t","yes","true",1].include?(params[:operational].downcase)
            @countries = @relation.all
            @data = ActiveModelSerializers::SerializableResource.new(@countries, each_serializer: CountryPreviewSerializer)
            @success = true
          end
          render_json_response(proc_code)
        end
      end
    end
  end
end

