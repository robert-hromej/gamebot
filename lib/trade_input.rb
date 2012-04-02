class TradeInput

  attr_accessor :resource_type, :count

  def initialize attributes
    self.resource_type = attributes["t"].to_i
    self.count = attributes["c"].to_i
  end

  def to_s
    "type:#{resource_type}:#{count}"
  end
end