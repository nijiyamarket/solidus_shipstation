# frozen_string_literal: true

RSpec.describe SolidusShipstation::Configuration do
  it 'logs the original error and context through the default handler' do
    error = StandardError.new('sync unavailable')
    context = { shipment: 'test-shipment' }
    allow(Rails.logger).to receive(:error)

    described_class.new.error_handler.call(error, context)

    expect(Rails.logger).to have_received(:error).with("#{error.inspect} (#{context.inspect})")
  end
end
