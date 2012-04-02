class Building
  attr_accessor :id, :type, :level

  def initialize attributes
    self.id = attributes["i"]
    self.type = attributes["v"]
    self.level = attributes["l"]

    fix_type()
  end

  def fix_type
    self.type = 35 if [291, 547, 804, 1060].include? self.type
    self.type = 36 if [292, 548, 805, 1061].include? self.type
    self.type = 37 if [293, 549, 806, 1062].include? self.type
    self.type = 38 if [294, 550, 806, 1062].include? self.type
    self.type = 39 if [295, 551, 807, 1063].include? self.type
    self.type = 40 if [296, 552, 808, 1064].include? self.type
    self.type = 41 if [297, 553, 809, 1065].include? self.type
    self.type = 42 if [298, 554, 810, 1066].include? self.type
    self.type = 43 if [299, 555, 811, 1067].include? self.type
    self.type = 44 if [300, 556, 812, 1068].include? self.type
    self.type = 45 if [301, 557, 813, 1069].include? self.type
    self.type = 46 if [302, 558, 814, 1070].include? self.type
  end

  def inspect
    "Building{:id => #{id}, :type => '#{type_name}', :level => #{level}"
  end

  def type_name
    $types[type] || type
  end
end
