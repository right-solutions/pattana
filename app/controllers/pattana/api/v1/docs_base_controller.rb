module Pattana
  module Api
    module V1
      class DocsBaseController < Kuppayam::BaseController

        layout 'kuppayam/docs'
        
        private

        def breadcrumbs_configuration
          {
            heading: "Pattana - API Documentation",
            description: "A brief documentation of all APIs implemented in the gem Pattana with input and output details and examples",
            links: []
          }
        end
        
      end
    end
  end
end
