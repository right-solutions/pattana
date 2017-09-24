module Pattana
  class Engine < ::Rails::Engine
    
    # require 'pry'
    require 'kaminari'
    require 'kuppayam'
    require 'colorize'
    require 'colorized_string'
    require 'active_model_serializers'
    
    isolate_namespace Pattana

    config.before_initialize do                                                      
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/dummy/spec/factories'
      g.assets false
      g.helper false
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
    
  end
end
