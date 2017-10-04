module Pattana
  class CountriesController < ResourceController

    def regions
      @country = Country.find_by_id(params[:id])
      @relation = @country.regions.limit(50)

      parse_filters
      apply_filters

      @filter_ui_settings[:operational][:drop_down_options] = {remote: true}
      @filter_ui_settings[:operational][:url_method_name] = "regions_country_url"
      @filter_ui_settings[:show_in_api][:drop_down_options] = {remote: true}
      @filter_ui_settings[:show_in_api][:url_method_name] = "regions_country_url"

      @regions = @relation.page(@current_page).per(@per_page)
    end

    def cities
      @country = Country.find_by_id(params[:id])
      @relation = @country.cities.limit(50)

      parse_filters
      apply_filters
      
      @filter_ui_settings[:operational][:drop_down_options] = {remote: true}
      @filter_ui_settings[:operational][:url_method_name] = "cities_country_url"
      @filter_ui_settings[:show_in_api][:drop_down_options] = {remote: true}
      @filter_ui_settings[:show_in_api][:url_method_name] = "cities_country_url"

      @cities = @relation.page(@current_page).per(@per_page)
    end

    def show_in_api
      @country = @r_object = Country.find(params[:id])
      if @country
        @country.show_in_api = true
        if @country.valid?
          @country.save
          set_notification(true, I18n.t('countries.show_in_api.heading'), I18n.t('countries.show_in_api.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @country.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def hide_in_api
      @country = @r_object = Country.find(params[:id])
      if @country
        @country.show_in_api = false
        if @country.valid?
          @country.save
          set_notification(true, I18n.t('countries.hide_in_api.heading'), I18n.t('countries.hide_in_api.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @country.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def mark_as_operational
      @country = @r_object = Country.find(params[:id])
      if @country
        @country.operational = true
        if @country.valid?
          @country.save
          set_notification(true, I18n.t('countries.marked_as_operational.heading'), I18n.t('countries.marked_as_operational.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @country.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def remove_operational
      @country = @r_object = Country.find(params[:id])
      if @country
        @country.operational = false
        if @country.valid?
          @country.save
          set_notification(true, I18n.t('countries.removed_operational.heading'), I18n.t('countries.removed_operational.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @country.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
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

      @relation = @relation.operational(@operational) unless @operational.nil?
      @relation = @relation.show_in_api(@show_in_api) unless @show_in_api.nil?

      @order_by = "priority, name ASC" unless @order_by
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
          url_method_name: 'countries_url',
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
          url_method_name: 'countries_url',
          show_all_filter_on_top: true,
          show_null_filter_on_top: false
        }
      }
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
        links: [{name: "Home", link: breadcrumb_home_path, icon: 'fa-home'}, 
                  {name: "Manage Countries", link: pattana.countries_path, icon: 'fa-flag-checkered', active: true}]
      }
    end

    def permitted_params
      params.require(:country).permit(:name, :official_name, :iso_name, 
                                      :fips, :iso_alpha_2, :iso_alpha_3,
                                      :itu_code, :dialing_prefix, :tld,
                                      :latitude, :longitude, :capital,
                                      :priority, :languages)
    end

    def set_navs
      set_nav("admin/countries")
    end

  end
end
