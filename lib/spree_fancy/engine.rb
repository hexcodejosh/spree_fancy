module SpreeFancy
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_fancy'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( store/print.css )

      Rails.application.config.assets.precompile << Proc.new do |path|
        if path =~ /\.(css|js|png|gif|eot|ttf|svg|woff)\z/
          full_path = Rails.application.assets.resolve(path).to_path
          #puts "including asset: " + full_path
        else
          #puts "excluding asset: " + path
        end
      end

    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
