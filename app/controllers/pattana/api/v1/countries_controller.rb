module Pattana
  module Api
    module V1
      class CountriesController < BaseController

        def index
          proc_code = Proc.new do
            @relation = Country.where("countries.show_in_api is true").order("countries.name ASC")
            @relation = @relation.search(params[:q]) if params[:q]
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

