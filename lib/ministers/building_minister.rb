module BuildingMinister

  def upgrade_buildings
    #return if data.nil?

    puts "Upgrade city '#{name}'"

    params = {cityid: id, isPaid: true}

    filtered_buildings.each do |building|

      return if build_limit?

      unless build_list.find_all { |l| l["b"] == building.id }.size > 0
        p "Upgrade #{building.inspect}"

        data = params.merge(buildingid: building.id, buildingType: building.type)
        response = send_request('UpgradeBuilding', data)
        response = JSON.parse(response)

        build_list = response["@u"]["CITY"]["q"] if response["@u"]["CITY"]["q"]

        sleep rand * 5 + 5
        return unless response["r"]
      end
    end
    sleep rand * 5 + 5
  rescue => ex
    puts ex
    puts ex.backtrace
    sleep rand * 5 + 5
  end

  private

  def build_limit?
    !!build_list and build_list.size == 6
  end

  def build_list=(list)
    @build_list = list
  end

  def buildings
    return @buildings if @buildings

    data.each { |item| self.buildings = item["D"]["u"] if item["C"] == "VIS" }

    @buildings ||= []
  end

  def buildings=(list)
    @buildings = Array(list).map { |attributes| Building.new attributes }
  end

  def build_list
    return @build_list if @build_list

    data.each { |item| self.build_list = item["D"]["q"] if item["C"] == "CITY" }

    @build_list ||= []
  end

  def filter
    return @filter if @filter

    @filter = (building_minister.is_a?(Symbol) ? $filters[building_minister] : Array(building_minister))
  end

  def filtered_buildings
    buildings.
      find_all { |b| !b.level.nil? }.
      find_all { |b| b.level < 10 }.
      find_all { |b| !b.type.nil? }.
      find_all { |b| filter.include?(b.type) }.
      sort_by { |b| b.level }
  end
end