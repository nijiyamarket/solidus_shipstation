# frozen_string_literal: true

module SolidusShipstation
  module Events
    NAMES = %i[
      solidus_shipstation.api.sync_skipped
      solidus_shipstation.api.sync_completed
      solidus_shipstation.api.sync_failed
      solidus_shipstation.api.sync_errored
      solidus_shipstation.api.rate_limited
    ].freeze

    def self.register
      return if defined?(::Spree::Event) || !defined?(::Spree::Bus)

      NAMES.each do |name|
        ::Spree::Bus.register(name) unless ::Spree::Bus.registry.registered?(name)
      end
    end

    def self.fire(name, **payload)
      if defined?(::Spree::Event)
        ::Spree::Event.fire(name, **payload)
      else
        ::Spree::Bus.publish(name.to_sym, **payload)
      end
    end
  end
end
