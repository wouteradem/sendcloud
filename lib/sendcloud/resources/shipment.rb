module Sendcloud
  class ShipmentResource < Resource

    def announce(**attributes)
      Shipment.new post_request("announce", body: attributes).body
    end
  end
end