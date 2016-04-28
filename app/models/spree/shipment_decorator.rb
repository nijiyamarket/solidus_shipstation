Spree::Shipment.class_eval do
  def self.exportable
    query = joins(:order).where(spree_orders: { state: 'complete' })
    query = query.where.not(spree_shipments: { state: 'pending' }) if Spree::Config.require_payment_to_ship
    query
  end

  def self.between(from, to)
    joins(:order).where(
      '(spree_shipments.updated_at > ? AND spree_shipments.updated_at < ?) OR
      (spree_orders.updated_at > ? AND spree_orders.updated_at < ?)',
      from, to, from, to
    )
  end
end
