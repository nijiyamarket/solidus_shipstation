# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

module SolidusShipstation
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_shipstation'

    initializer 'solidus_shipstation.events', after: 'spree.core.pub_sub' do |app|
      app.reloader.to_prepare { SolidusShipstation::Events.register }
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
