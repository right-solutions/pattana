module Pattana
  class CountriesController < ResourceController

    def regions
      @country = Country.find_by_id(params[:id])
      @relation = @country.regions.limit(50)

      parse_filters
      apply_filters

      @regions = @relation.page(@current_page).per(@per_page)
    end

    private

    def get_collections
      @relation = Country.where("")

      parse_filters
      apply_filters
      
      @countries = @r_objects = @relation.page(@current_page).per(@per_page)

      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      @order_by = "priority, name ASC" unless @order_by
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
        page_title: "Countries",
        js_view_path: "/kuppayam/workflows/peacock",
        view_path: "/pattana/countries"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Countries",
        icon: "fa-flag-checkered",
        description: "Listing all Countries",
        links: [{name: "Dashboard", link: pattana.dashboard_path, icon: 'fa-dashboard'}, 
                  {name: "Manage Countries", link: pattana.countries_path, icon: 'fa-flag-checkered', active: true}]
      }
    end

    def permitted_params
      params.require(:country).permit(:name)
    end

    def set_navs
      set_nav("admin/countries")
    end

  end
end
