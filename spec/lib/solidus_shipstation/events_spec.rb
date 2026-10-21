# frozen_string_literal: true

RSpec.describe SolidusShipstation::Events do
  it 'preserves the legacy event API when available' do
    legacy = double('Spree::Event', fire: nil)
    stub_const('Spree::Event', legacy)

    described_class.fire('solidus_shipstation.api.sync_completed', shipment: :shipment)

    expect(legacy).to have_received(:fire).with('solidus_shipstation.api.sync_completed', shipment: :shipment)
  end

  context 'without the legacy event API' do
    let(:registry) { double('registry', registered?: false) }
    let(:bus) { double('bus', registry: registry, register: nil, publish: nil) }

    before do
      hide_const('Spree::Event')
      stub_const('Spree::Bus', bus)
    end

    it 'registers the integration events on the current bus' do
      described_class.register

      described_class::NAMES.each { |name| expect(bus).to have_received(:register).with(name) }
    end

    it 'does not register an existing event again' do
      allow(registry).to receive(:registered?).and_return(true)

      described_class.register

      expect(bus).not_to have_received(:register)
    end

    it 'publishes a symbol event with the original payload' do
      described_class.fire('solidus_shipstation.api.sync_completed', shipment: :shipment)

      expect(bus).to have_received(:publish).with(:'solidus_shipstation.api.sync_completed', shipment: :shipment)
    end
  end
end
