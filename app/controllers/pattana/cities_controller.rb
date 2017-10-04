module Pattana
  class CitiesController < ResourceController

    def show_in_api
      @city = @r_object = City.find(params[:id])
      if @city
        @city.show_in_api = true
        if @city.valid?
          @city.save
          set_notification(true, I18n.t('cities.show_in_api.heading'), I18n.t('cities.show_in_api.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @city.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def hide_in_api
      @city = @r_object = City.find(params[:id])
      if @city
        @city.show_in_api = false
        if @city.valid?
          @city.save
          set_notification(true, I18n.t('cities.hide_in_api.heading'), I18n.t('cities.hide_in_api.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @city.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def mark_as_operational
      @city = @r_object = City.find(params[:id])
      if @city
        @city.operational = true
        if @city.valid?
          @city.save
          set_notification(true, I18n.t('cities.marked_as_operational.heading'), I18n.t('cities.marked_as_operational.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @city.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    def remove_operational
      @city = @r_object = City.find(params[:id])
      if @city
        @city.operational = false
        if @city.valid?
          @city.save
          set_notification(true, I18n.t('cities.removed_operational.heading'), I18n.t('cities.removed_operational.message'))
        else
          set_notification(false, I18n.t('status.error'), I18n.translate("error"), @city.errors.full_messages.join("<br>"))
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.error', item: default_item_name.titleize))
      end
      render_row
    end

    private

    def get_collections
      @relation = City.includes(:country, :region).where("")

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
        links: [{name: "Home", link: breadcrumb_home_path, icon: 'fa-home'}, 
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
