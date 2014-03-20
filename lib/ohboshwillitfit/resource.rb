module OhBoshWillItFit
  class Resource
    attr_accessor :instance_type
    attr_accessor :size

    def self.from_file(deployment_path)
      resource_pools = YAML.load_file(deployment_path)["resource_pools"]
      resource_pools.map do |pool|
        resource = self.new
        resource.size = pool["size"]
        resource.instance_type = pool["cloud_properties"]["instance_type"]
        resource
      end
    end

  end
end
