class World

  attr_accessor :options, :session, :cookie, :referer, :host, :path

  def initialize(options)
    self.options = options
    self.host = options[:settings][:host]
    self.path = options[:settings][:path]
    self.session = options[:settings][:session]
    self.cookie = options[:settings][:cookie]
    self.referer = options[:settings][:referer]
  end

  def upgrade_all_city
    options[:cities].each do |name, option|
      puts "Upgrade city '#{name}'"
      city = City.new(self, option)
      city.upgrade
      sleep rand * 5 + 5
    end
  end

end
