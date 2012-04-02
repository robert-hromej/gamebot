module TradeMinister

  TRADE_SIZE = 10000
  PERCENT = 0.65

  def wood_city?
    trade_minister[0] == :out
  end

  def stone_city?
    trade_minister[1] == :out
  end

  def iron_city?
    trade_minister[2] == :out
  end

  def food_city?
    trade_minister[3] == :out
  end

  def trade
    return @trade if @trade

    data.each do |item|
      if item["C"] == "CITY"
        item["D"]["t"].each do |t|
          @trade = Trade.new(t) if t['t'] == 1
        end
      end
    end

    @trade
  end

  def pull_resources
    puts "TradeMinister city '#{name}'"
    trade_minister.each_with_index do |status, index|
      pull_resource(index+1) if status == :in
    end
  end

  def find_resource(type)
    resources.find { |r| r.type == type }
  end

  private

  def pull_resource resource_type
    p "pull resource type '#{resource_type}'"
    resource = find_resource resource_type

    return if resource.nil?

    need = (resource.maximum * PERCENT) - resource.balance

    need -= input_trade_resource(resource_type)

    if need >= TRADE_SIZE
      cities = case resource_type
               when 1 then world.wood_cities
               when 2 then world.stone_cities
               when 3 then world.iron_cities
               when 4 then world.food_cities
               end
      cities.sort_by! do |city|
        res = city.find_resource resource_type
        (res.maximum / res.balance)
      end

      cities.each do |city|
        input = city.find_resource resource_type
        if input.balance >= TRADE_SIZE and city.trade.count >= TRADE_SIZE/1000
          if request_resource(resource_type, city.id) == "0"
            input.balance -= TRADE_SIZE
            city.trade.count -= TRADE_SIZE/1000
            need -= TRADE_SIZE
            return if need < TRADE_SIZE
          end
        end
      end
    end
  end

  def resources
    return @resources if @resources

    data.each { |item| self.resources = item["D"]["r"] if item["C"] == "CITY" }

    @resources ||= []
  end

  def resources=(list)
    @resources = Array(list).map { |attributes| Resource.new attributes }
  end

  def trade_inputs
    return @trade_inputs if @trade_inputs

    @trade_inputs = []

    data.each do |item|
      if item["C"] == "CITY"
        Array(item["D"]["ti"]).each do |ti|
          @trade_inputs += ti["r"].map { |t| TradeInput.new t }
        end
      end
    end

    @trade_inputs

    #{
    #   "i" : 4203447,
    #   "t" : 2,
    #   "tt" : 1,
    #   "ss" : 6441726,
    #   "es" : 6445989,
    #   "s" : 1,
    #   "c" : 21692553,
    #   "cn" :"Uzhgorod",
    #   "p" : 6273,
    #   "pn" :"gida102",
    #   "a" : 221,
    #   "an" :"The Three Lions",
    #   "r" : [{"t" : 1, "c" : 200000}]}
  end

  def input_trade_resource type
    trade_inputs.
      find_all { |trade| trade.resource_type == type }.
      collect(&:count).
      inject(0) { |s, c| s += c }
  end

  def request_resource resource_type, from_city_id

    params = {cityid: from_city_id,
              palaceSupport: false,
              targetCity: coordinate,
              targetPlayer: 'gida102',
              tradeTransportType: 1,
              res: [{t: resource_type, c: 10000}]}

    response = send_request('TradeDirect', params)
    sleep rand * 5 + 5
    response
  rescue => ex
    sleep rand * 5 + 5
    1
  end


end