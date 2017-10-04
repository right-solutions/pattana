module Pattana
  class RegionsController < ResourceController

    def cities
      @region = Region.find_by_id(params[:id])
      @relation = @region.cities.limit(50)

      parse_filters
      apply_filters

      @filter_ui_settings[:operational][:drop_down_options] = {remote: true}
      @filter_ui_settings[:operational][:url_method_name] = "cities_region_url"
      @filter_ui_settings[:show_in_api][:drop_down_options] = {remote: true}
      @filter_ui_settings[:show_in_api][:url_method_name] = "cities_region_url"

      @cities = @relation.page(@current_page).per(@per_page)
    end

    def show_in_api
      @region = @r_object = Region.find(params[:id])
      if @region
        @region.show_in_api = true
        if @region.valid?
          @region.save
          set_notification(true, I18n.t('regions.show_in_api.heading'), I18n.t('regions.show_in_api.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @region.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def hide_in_api
      @region = @r_object = Region.find(params[:id])
      if @region
        @region.show_in_api = false
        if @region.valid?
          @region.save
          set_notification(true, I18n.t('regions.hide_in_api.heading'), I18n.t('regions.hide_in_api.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @region.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def mark_as_operational
      @region = @r_object = Region.find(params[:id])
      if @region
        @region.operational = true
        if @region.valid?
          @region.save
          set_notification(true, I18n.t('regions.marked_as_operational.heading'), I18n.t('regions.marked_as_operational.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @region.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def remove_operational
      @region = @r_object = Region.find(params[:id])
      if @region
        @region.operational = false
        if @region.valid?
          @region.save
          set_notification(true, I18n.t('regions.removed_operational.heading'), I18n.t('regions.removed_operational.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @region.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    private

    def get_collections
      @relation = Region.includes(:country).where("")

      parse_filters
      apply_filters
      
      @regions = @r_objects = @relation.page(@current_page).per(@per_page)

      return true
    end

    def apply_filters

      @relation = @relation.search(@query) if @query

      @relation = @relation.operational(@operational) unless @operational.nil?
      @relation = @relation.show_in_api(@show_in_api) unless @show_in_api.nil?

      @order_by = "name ASC" unless @order_by
      @relation = @relation.order(@order_by)
    end

    def configure_filter_settings
      @filter_settings = {
        string_filters: [
          { filter_name: :query },
          { filter_name: :status }
        ],
        boolean_filters: [
          { filter_name: :show_in_api },
          { filter_name: :operational }
        ],
        reference_filters: [],
        variable_filters: [],
      }
    end

    def configure_filter_ui_settings
      @filter_ui_settings = {
        operational: {
          object_filter: false,
          select_label: "Operation Filter",
          display_hash: { 
            true => "Operational", 
            false => "Non Operational"
          },
          current_value: @operational,
          values: {
            "Operational" => true,
            "Non Operational" => false
          },
          current_filters: @filters,
          filters_to_remove: [],
          filters_to_add: { query: @query, show_in_api: @show_in_api },
          url_method_name: 'regions_url',
          show_all_filter_on_top: true,
          show_null_filter_on_top: false
        },
        show_in_api: {
          object_filter: false,
          select_label: "Show in API Filter",
          display_hash: { 
            true => "Show in API", 
            false => "Hide in API"
          },
          current_value: @show_in_api,
          values: {
            "Show in API" => true,
            "Hide in API" => false
          },
          current_filters: @filters,
          filters_to_remove: [],
          filters_to_add: { query: @query, operational: @operational },
          url_method_name: 'regions_url',
          show_all_filter_on_top: true,
          show_null_filter_on_top: false
        }
      }
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
        links: [{name: "Home", link: breadcrumb_home_path, icon: 'fa-home'}, 
                  {name: "Manage Regions", link: pattana.regions_path, icon: 'fa-globe', active: true}]
      }
    end

    def permitted_params
      params.require(:region).permit(:name, :iso_code, :latitude, :longitude, :country_id)
    end

    def set_navs
      set_nav("admin/regions")
    end

  end
end
