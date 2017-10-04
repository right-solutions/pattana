module Pattana
  class ApplicationController < Kuppayam::BaseController

    layout 'kuppayam/admin'

    private

    def set_default_title
      set_title("Pattana Admin - Database of Countries, Regions and Cities")
    end

    def configure_filter_param_mapping
      @filter_param_mapping = default_filter_param_mapping
      @filter_param_mapping[:show_in_api] = :show_in_api
      @filter_param_mapping[:operational] = :operational
    end

    def breadcrumb_home_path
      pattana.dashboard_path
    end
    
  end
end
