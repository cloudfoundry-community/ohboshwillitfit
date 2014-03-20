module OhBoshWillItFit
  class Limits
    attr_reader :fog_compute

    def initialize(fog_compute)
      @fog_compute = fog_compute
    end

    def max_total_cores
      limits.data[:body]["limits"]["absolute"]["maxTotalCores"]
    end

    def max_total_instances
      limits.data[:body]["limits"]["absolute"]["maxTotalInstances"]
    end

    def max_total_ram_size
      limits.data[:body]["limits"]["absolute"]["maxTotalRAMSize"]
    end

    def limits
      @limits ||= fog_compute.get_limits
    end

  end
end
