module Pattana
	class ResourceController < ApplicationController

		include ResourceHelper

	  before_action :configure_resource_controller

	end
end
