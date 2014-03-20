module OhBoshWillItFit
  class Resource
    attr_accessor :instance_type
    attr_accessor :size

    attr_accessor :ram, :total_ram
    attr_accessor :disk, :total_disk
    attr_accessor :cpus, :total_cpus

    attr_accessor :error

    def self.from_file(deployment_path)
      resource_pools = YAML.load_file(deployment_path)["resource_pools"]
      resource_pools.map do |pool|
        resource = self.new
        resource.size = pool["size"]
        resource.instance_type = pool["cloud_properties"]["instance_type"]
        resource
      end
    end

    def self.map_flavors!(resources, flavors)
      resources.each do |resource|
        if flavor = resource.find_flavor(flavors)
          resource.apply_flavor(flavor)
        else
          resource.error = "Not a valid flavor/instance_type"
        end
      end
    end

    def self.resource_totals(resources)
      totals = { "ram" => 0, "disk" => 0, "cpus" => 0 }
      resources.each do |resource|
        totals["ram"] += resource.total_ram
        totals["disk"] += resource.total_disk
        totals["cpus"] += resource.total_cpus
      end
      totals
    end

    def find_flavor(flavors)
      flavors.find { |flavor| flavor.name == instance_type }
    end

    def apply_flavor(flavor)
      self.ram = flavor.ram
      self.disk = flavor.disk
      self.cpus = flavor.vcpus
      update_totals!
    end

    def update_totals!
      self.total_ram = size * ram
      self.total_disk = size * disk
      self.total_cpus = size * cpus
    end

  end
end
