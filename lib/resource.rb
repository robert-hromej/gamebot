class Resource

  attr_accessor :type, :balance, :maximum, :per_second

  def initialize attributes, fc = nil
    self.type = attributes["i"].to_i
    self.balance = attributes["b"].to_f
    self.maximum = attributes["m"].to_i
    self.per_second = attributes["d"].to_f

    self.per_second -= fc if fc and type == 4
  end

  def to_s
    "#{type_name}: #{balance}(#{maximum})"
  end

  private

  def type_name
    case type
    when 1 then "Wood"
    when 2 then "Stone"
    when 3 then "Iron"
    when 4 then "Food"
    end
  end
end