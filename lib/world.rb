class World

  attr_accessor :options, :session, :cookie, :referer, :host, :path
  attr_reader :cities

  def initialize(options)
    self.options = options
    self.host = options[:settings][:host]
    self.path = options[:settings][:path]
    self.session = options[:settings][:session]
    self.cookie = options[:settings][:cookie]
    self.referer = options[:settings][:referer]
    self.cities = options[:cities]
  end

  def cities=(_cities)
    @cities = _cities.map { |name, option| City.new(self, name, option) }
  end

  def building_minister
    cities.each { |city| city.upgrade_buildings }
  rescue => ex
    puts ex.message
    puts ex.backtrace
  end

  def trade_minister
    cities.each { |city| city.pull_resources }
  rescue => ex
    puts ex.message
    puts ex.backtrace
  end

  def wood_cities
    cities.find_all { |city| city.wood_city? }
  end

  def stone_cities
    cities.find_all { |city| city.stone_city? }
  end

  def iron_cities
    cities.find_all { |city| city.iron_city? }
  end

  def food_cities
    cities.find_all { |city| city.food_city? }
  end
end
