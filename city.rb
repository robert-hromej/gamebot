class City

  attr_accessor :id, :buildings, :list
  attr_reader :world, :filter

  def initialize(world, options)
    @world = world

    self.id = options[:id]
    self.filter = options[:filter]
    self.buildings = []
    self.list = []

    load_map()
  end

  def filter=(option)
    @filter = option if option.is_a?(Array)
    @filter = [option] if option.is_a?(Integer)
    @filter = $filters[option] if option.is_a?(Symbol)
  end

  def parse_buildings(array)
    array.each { |options| self.buildings << Building.new(options) }
  end

  def upgrade
    params = {'cityid' => id, 'isPaid' => true}

    filtered_buildings.each do |building|

      return if self.list and self.list.size == 6

      self.list ||= []

      unless self.list.find_all { |l| l["b"] == building.id }.size > 0
        p "Upgrade #{building.inspect}"

        data = params.merge("buildingid" => building.id, "buildingType" => building.type)
        response = send_request('UpgradeBuilding', data)
        response = JSON.parse(response)

        self.list = response["@u"]["CITY"]["q"] if response["@u"]["CITY"]["q"]

        sleep rand * 5 + 5
        return unless response["r"]
      end
    end
  end

  def filtered_buildings
    self.buildings.
        find_all { |b| !b.level.nil? }.
        find_all { |b| b.level < 10 }.
        find_all { |b| !b.type.nil? }.
        find_all { |b| filter.include?(b.type) }.
        sort_by { |b| b.level }
  end

  def load_map
    $resuests += 1
    data = {
        "requestid" => $resuests,
        "requests" => "TM:#{rand(100) + 200},0,\fCAT:2\fSERVER:\fFW:\fALLIANCE:\fQUEST:\fTE:\fPLAYER:\fCITY:#{id}\fWC:\fWORLD:\fVIS:c:#{id}:0:-1034:-609:876:623\fUFP:\fREPORT:\fMAIL:\fFRIENDINV:\fTIME:#{(Time.new.to_f*1000).to_i}\fCHAT:\fSUBSTITUTION:\fEC:\fINV:\fAI:\fMAT:#{id}\fFRIENDL:\f"}
    response = send_request("Poll", data)
    response = JSON.parse(response)
    response.each do |item|
      if item == {"C" => "SYS", "D" => "KICKED"} or item == {"C"=>"SYS", "D"=>"CLOSED"}
        p "Please update session key"
        sleep rand * 5 + 5
        return
      end
      self.list = item["D"]["q"] if item["C"] == "CITY"
      parse_buildings(item["D"]["u"]) if item["C"] == "VIS"
    end
  end

  private

  def send_request(method, data)
    http = Net::HTTP.new(world.host, 80)
    path = world.path + method
    data.merge!("session" => world.session)
    headers = {
        'Cookie' => world.cookie,
        'Referer' => world.referer,
        'Content-Type' => 'application/json; charset=utf-8'
    }
    resp, data = http.post(path, data.to_json, headers)
    data
  end

end
