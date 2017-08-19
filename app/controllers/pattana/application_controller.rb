module Pattana
  class ApplicationController < Kuppayam::BaseController

    layout 'kuppayam/admin'

    private

    def set_default_title
      set_title("Pattana Admin - Database of Countries, Regions and Cities")
    end
    
  end
end
