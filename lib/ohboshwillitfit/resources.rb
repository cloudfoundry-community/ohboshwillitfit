module OhBoshWillItFit
  class Resources
    attr_reader :deployment_path

    def initialize(deployment_path)
      @deployment_path = deployment_path
    end

    def resources
      resource_pools = YAML.load_file(deployment_path)["resource_pools"]
      resource_pools.inject({}) do |resources, pool|
        size = pool["size"]
        instance_type = pool["cloud_properties"]["instance_type"]
        resources[instance_type] = {
          "size" => size
        }
        resources
      end
    end

    def resources_from_flavors(flavors)
      resources
    end
  end
end
