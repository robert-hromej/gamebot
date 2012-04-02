class Trade
  attr_accessor :type, :count, :total_count

  def initialize attributes
    self.type = attributes["t"].to_i
    self.count = attributes["c"].to_i
    self.total_count = attributes["tc"].to_i
  end
end