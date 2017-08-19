module Pattana
  class RegionsController < ResourceController

    private

    def get_collections
      @relation = Region.where("")

      parse_filters
      apply_filters
      
      @regions = @r_objects = @relation.page(@current_page).per(@per_page)

      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
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
        page_title: "Regions",
        js_view_path: "/kuppayam/workflows/peacock",
        view_path: "/pattana/regions"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Regions",
        icon: "fa-globe",
        description: "Listing all Regions",
        links: [{name: "Dashboard", link: pattana.dashboard_path, icon: 'fa-dashboard'}, 
                  {name: "Manage Regions", link: pattana.regions_path, icon: 'fa-globe', active: true}]
      }
    end

    def permitted_params
      params.require(:region).permit(:name)
    end

    def set_navs
      set_nav("admin/regions")
    end

  end
end
