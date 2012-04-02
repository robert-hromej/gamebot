require './lib/resource'
require './lib/trade_input'
require './lib/trade'
require './lib/ministers/building_minister'
require './lib/ministers/trade_minister'

class City
  include BuildingMinister
  include TradeMinister

  attr_accessor :id, :name, :building_minister, :trade_minister
  attr_reader :world

  def initialize(world, name, options)
    @world = world

    self.id = options[:id]
    self.name = name

    self.building_minister = options[:building_minister]
    self.trade_minister = options[:trade_minister]

    load_map()
  end

  def data
    return @data if @data

    load_map()

    @data
  end

  def coordinate
    return @coordinate if @coordinate

    data.each do |item|
      if item["C"] == "PLAYER"
        item["D"]["c"].each do |c|
          @coordinate = [c["x"], c["y"]].join(':') if c["i"] == id
        end
      end
    end

    @coordinate
  end

  private

  def load_map
    p "Loading map '#{name}'"
    $resuests += 1
    data = {
      "requestid" => $resuests,
      "requests" => "TM:#{rand(500) + 200},0,\fCAT:1\fSERVER:\fALLIANCE:\fQUEST:\fTE:\fFW:\fPLAYER:\fCITY:#{id}\fWC:\fWORLD:\fVIS:c:#{id}:0:-724:-696:1496:448:1\fUFP:\fREPORT:\fMAIL:\fFRIENDINV:\fTIME:#{(Time.new.to_f*1000).to_i}\fCHAT:\fSUBSTITUTION:\fEC:\fINV:\fAI:\fMAT:#{id}\f"}
    response = send_request("Poll", data)
    response = JSON.parse(response)

    @data = response

    response.each do |item|
      #p item
      if item == {"C" => "SYS", "D" => "KICKED"} or item == {"C" => "SYS", "D" => "CLOSED"}
        p "Please update session key"
        @data = []
        sleep rand * 5 + 5
        return
      end
    end

    sleep rand * 5 + 5
  rescue => ex
    puts ex
    sleep rand * 5 + 5
  end

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


{"C" => "CITY",
 "D" => {
   "v" => 1397,
   "n" => "City of gida102",
   "uc" => 71645,
   "ul" => 196000,
   "bc" => 100,
   "bl" => 100,
   "ol" => 15,
   "tb" => 0,
   "tr" => 0,
   "bqs" => 0,
   "bqe" => 0,
   "sh" => true,
   "s" => false,
   "cr" => true,
   "w" => 0,
   "cpr" => true,
   "st" => 0,
   "et" => 0,
   "bbl" => 490,
   "tl" => 10,
   "wl" => 10,
   "mpl" => 10,
   "hrl" => 0,
   "mtl" => 10,
   "pl" => 0,
   "btam" => 0.0,
   "btpm" => 1242.0,
   "hs" => 0.0,
   "fc" => 4.438297271728516,
   "fcs" => 0.0,
   "fcq" => 0.11736106872558594,
   "pp" => 0,
   "g" => 0.0,
   "nr" => "",
   "ns" => "",
   "ad" => true,
   "ae" => true,
   "f" => 0,
   "at" => 137,
   "k" => false,
   "ts" => [710, 286],
   "r" => [
     {"i" => 4, "s" => 6429373, "b" => 749118.868063837, "d" => 3.5, "m" => 975000},
     {"i" => 3, "s" => 6429373, "b" => 82704.9478123829, "d" => 1.9635, "m" => 975000},
     {"i" => 2, "s" => 6429373, "b" => 561106.669472959, "d" => 0, "m" => 575000},
     {"i" => 1, "s" => 6429373, "b" => 423787.666666667, "d" => 0.0833333333333333, "m" => 575000}],
   "pwr" => 0,
   "psr" => 0,
   "pd" => 0,
   "q" => nil,
   "uq" => [
     {"i" => 2975326, "t" => 10, "c" => 14, "l" => 513, "o" => 611, "ss" => 6429373, "es" => 6438607, "be" => 6429625, "p" => true, "m" => false},
     {"i" => 2990834, "t" => 10, "c" => 1, "l" => 163, "o" => 163, "ss" => 6438607, "es" => 6441541, "be" => 0, "p" => true, "m" => false}],
   "uo" => [
     {"i" => 1747464, "d" => false, "t" => 10, "ss" => 6411085, "es" => 6442492, "s" => 1, "q" => 0, "c" => 20971684, "cn" => "Boss Forest:5", "p" => -9223372036854775808, "pn" => "", "a" => 0, "an" => "", "x" => 164, "y" => 320, "rt" => 0, "rs" => 0, "opt" => 0, "m" => false, "ms" => 0,
      "u" => [
        {"t" => 3, "c" => 227},
        {"t" => 5, "c" => 28159},
        {"t" => 6, "c" => 68},
        {"t" => 7, "c" => 16}]},
     {"i" => 1747471, "d" => false, "t" => 1, "ss" => 6424751, "es" => 6438403, "s" => 2, "q" => 0, "c" => 20840614, "cn" => "Lawless city", "p" => 0, "pn" => "", "a" => 0, "an" => "", "x" => 166, "y" => 318, "rt" => 0, "rs" => 0, "opt" => 0, "m" => false, "ms" => 0,
      "u" => [{"t" => 8, "c" => 830}]}],
   "su" => nil,
   "iuo" => nil,
   "u" => [
     {"t" => 1, "c" => 18425, "tc" => 18425, "s" => 0},
     {"t" => 2, "c" => 718, "tc" => 718, "s" => 1800},
     {"t" => 5, "c" => 1841, "tc" => 30000, "s" => 1200},
     {"t" => 9, "c" => 163, "tc" => 163, "s" => 600},
     {"t" => 10, "c" => 14035, "tc" => 14035, "s" => 600},
     {"t" => 11, "c" => 43, "tc" => 43, "s" => 600},
     {"t" => 12, "c" => 6, "tc" => 6, "s" => 600},
     {"t" => 13, "c" => 200, "tc" => 200, "s" => 1800},
     {"t" => 14, "c" => 200, "tc" => 200, "s" => 1800},
     {"t" => 3, "c" => 0, "tc" => 227, "s" => 1200},
     {"t" => 6, "c" => 0, "tc" => 68, "s" => 1200},
     {"t" => 7, "c" => 0, "tc" => 16, "s" => 1200},
     {"t" => 8, "c" => 0, "tc" => 830, "s" => 480}],
   "t" => [{"t" => 1, "c" => 200, "tc" => 400},
           {"t" => 2, "c" => 0, "tc" => 0}],
   "to" => nil,
   "ti" => nil,
   "tf" => [{"i" => 70781, "d" => 86400, "p" => 2100, "r" => 2, "t" => 1, "a" => 200}],
   "rs" => [{"t" => 1, "a" => 0, "p" => 250},
            {"t" => 2, "a" => 0, "p" => 400},
            {"t" => 3, "a" => 0, "p" => 700},
            {"t" => 4, "a" => 0, "p" => 100},
            {"t" => 5, "a" => 0, "p" => 400},
            {"t" => 6, "a" => 0, "p" => 3975},
            {"t" => 7, "a" => 0, "p" => 250}],
   "mo" => {"68" => 26000, "71" => 10000, "62" => 300, "15" => 1142, "8" => 1200, "114" => 200, "21" => 400, "50" => 300, "120" => 240, "53" => 200, "4" => 575000, "6" => 575000, "10" => 575000, "9" => 575000, "25" => 200, "37" => 3, "66" => 50, "20" => 49000, "74" => 1000, "64" => 3875, "18" => 600, "36" => 15, "67" => 300, "3" => 300, "12" => 100, "63" => 150, "65" => 1, "17" => 300, "38" => 36000, "72" => 500, "16" => 150, "76" => 2000, "34" => 400, "7" => 1200, "95" => 200, "22" => 360, "47" => 300, "119" => 168, "26" => 200, "69" => 2500, "73" => 1000},
   "ef" => nil,
   "tbc" => {"41" => 13, "42" => 5, "44" => 1, "38" => 1, "46" => 2, "39" => 1, "43" => 1},
   "ta" => [
     {"t" => 1, "c" => 10000},
     {"t" => 3, "c" => 200},
     {"t" => 5, "c" => 1440},
     {"t" => 6, "c" => 100},
     {"t" => 7, "c" => 20},
     {"t" => 8, "c" => 100},
     {"t" => 10, "c" => 2500},
     {"t" => 11, "c" => 400},
     {"t" => 12, "c" => 60},
     {"t" => 19, "c" => 1}]}}


{"C" => "PLAYER",
 "D" => {
   "v" => 10269,
   "g" => {"b" => 4135479.85939081, "d" => 0.0, "s" => 6445443},
   "m" => {"b" => 49000, "d" => 0.16666666666666663, "s" => 6444490, "m" => 50000},
   "ms" => {"b" => 319166.579861111, "d" => 0.2025462962962963, "s" => 6444490, "m" => -1},
   "d" => 0, "t" => 7,
   "p" => 104290, "r" => 404,
   "bc" => 11, "b" => 11, "bi" => 0, "bq" => 0, "bqs" => 6, "uqs" => 4,
   "sos" => 626413, "mbp" => false, "mbe" => 0, "mdp" => false, "mde" => 0,
   "mmp" => false, "mme" => 0, "mtp" => false, "mte" => 0, "cds" => 4281894, "fd" => 17049342, "fo" => 528145,
   "tds" => 2660919, "brs" => 6322809, "tls" => 0,
   "c" => [
     {"i" => 21692553, "n" => "Uzhgorod", "x" => 137, "y" => 331, "r" => "", "t" => 36, "f" => 36},
     {"i" => 21233801, "n" => "Oslo", "x" => 137, "y" => 324, "r" => "", "t" => 15, "f" => 36},
     {"i" => 21168266, "n" => "City of gida102", "x" => 138, "y" => 323, "r" => "", "t" => 6, "f" => 36},
     {"i" => 21954703, "n" => "SOM", "x" => 143, "y" => 335, "r" => "", "t" => 5, "f" => 36},
     {"i" => 22085776, "n" => "Krista", "x" => 144, "y" => 337, "r" => "", "t" => 5, "f" => 36},
     {"i" => 21758098, "n" => "Sevlush", "x" => 146, "y" => 332, "r" => "", "t" => 4, "f" => 36},
     {"i" => 21430417, "n" => "Odessa", "x" => 145, "y" => 327, "r" => "", "t" => 4, "f" => 36},
     {"i" => 21758087, "n" => "Vinogradov", "x" => 135, "y" => 332, "r" => "", "t" => 4, "f" => 36},
     {"i" => 22151308, "n" => "Rosa", "x" => 140, "y" => 338, "r" => "", "t" => 2, "f" => 36},
     {"i" => 21561490, "n" => "Kiev", "x" => 146, "y" => 329, "r" => "", "t" => 4, "f" => 36},
     {"i" => 21627025, "n" => "Sprite", "x" => 145, "y" => 330, "r" => "", "t" => 4, "f" => 36},
     {"i" => 22085761, "n" => "IronMan", "x" => 129, "y" => 337, "r" => "", "t" => 5, "f" => 36}],
   "rc" => [],
   "vr" => [[8, 26], [7, 171], [6, 2090], [5, 1014]], "os" => [[0, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 5, 0, 0, 0], [0, -1, 0, 0, 0], [-1, 0, 0, 0, 0]], "tt" => [293, 885, 888, 911, 915], "mo" => {"96" => 11, "97" => 1, "98" => 3, "111" => 1, "113" => 1}, "cg" => []}}