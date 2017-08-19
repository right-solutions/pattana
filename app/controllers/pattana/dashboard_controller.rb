module Pattana
  class DashboardController < ApplicationController

  	# GET /dashboard
    def index
    end

    private

    def breadcrumbs_configuration
      {
        heading: "Dashboard - Pattana",
        description: "A Quick view of Countries, Regions & Cities",
        links: [{name: "Dashboard - Pattana", link: pattana.dashboard_path, icon: 'fa-dashboard'}]
      }
    end

    def set_navs
      set_nav("master_data/dashboard")
    end

  end
end

