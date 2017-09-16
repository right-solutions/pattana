module Pattana
  class CitiesController < ResourceController

    private

    def get_collections
      @relation = City.where("")

      parse_filters
      apply_filters
      
      @cities = @r_objects = @relation.page(@current_page).per(@per_page)

      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      @relation = @relation.status(@status) if @status
      
      @order_by = "name ASC" unless @order_by
      @relation = @relation.order(@order_by)
    end

    def configure_filter_settings
      @filter_settings = {
        string_filters: [
          { filter_name: :query },
          { filter_name: :status }
        ],
        boolean_filters: [],
        reference_filters: [],
        variable_filters: [],
      }
    end

    def configure_filter_ui_settings
      @filter_ui_settings = {}
    end

    def resource_controller_configuration
      {
        page_title: "Cities",
        js_view_path: "/kuppayam/workflows/peacock",
        view_path: "/pattana/cities"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Cities",
        icon: "fa-map-marker",
        description: "Listing all Cities",
        links: [{name: "Dashboard", link: pattana.dashboard_path, icon: 'fa-dashboard'}, 
                  {name: "Manage Cities", link: pattana.cities_path, icon: 'fa-map-marker', active: true}]
      }
    end

    def permitted_params
      params.require(:city).permit(:name, :alternative_names, :iso_code, :population, :latitude, :longitude, :country_id, :region_id)
    end

    def set_navs
      set_nav("admin/cities")
    end

  end
end
