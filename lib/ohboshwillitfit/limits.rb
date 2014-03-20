module OhBoshWillItFit
  class Limits
    attr_reader :fog_compute

    def initialize(fog_compute)
      @fog_compute = fog_compute
    end

    def max_total_cores
      absolute_limits["maxTotalCores"]
    end

    def max_total_instances
      absolute_limits["maxTotalInstances"]
    end

    def max_total_ram_size
      absolute_limits["maxTotalRAMSize"]
    end

    def total_cores_used
      absolute_limits["totalCoresUsed"]
    end

    def total_instances_used
      absolute_limits["totalInstancesUsed"]
    end

    def total_ram_size_used
      absolute_limits["totalRAMUsed"]
    end

    def limits
      @limits ||= fog_compute.get_limits
    end

    def absolute_limits
      limits.data[:body]["limits"]["absolute"]
    end

  end
end
