module Pattana
  module Api
    module V1
      class BaseController < ActionController::API

        include ActionController::HttpAuthentication::Token::ControllerMethods
        include ApiHelper

      end
    end
  end
end
