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

    def limits
      @limits ||= fog_compute.get_limits
    end

    def absolute_limits
      limits.data[:body]["limits"]["absolute"]
    end

  end
end
