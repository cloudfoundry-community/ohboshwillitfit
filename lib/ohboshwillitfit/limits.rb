module OhBoshWillItFit
  class Limits
    attr_reader :fog_compute, :fog_volumes

    def initialize(fog_compute, fog_volumes)
      @fog_compute = fog_compute
      @fog_volumes = fog_volumes
    end

    def max_total_cores
      compute_quotas["cores"]
    end

    def max_total_instances
      compute_quotas["instances"]
    end

    def max_total_ram_size
      compute_quotas["ram"]
    end

    def max_total_volume_size
      volume_quotas["gigabytes"]
    end

    def max_total_volumes
      volume_quotas["volumes"]
    end


    def total_cores_used
      compute_servers.inject(0) { |total, server| total + flavor_for_server(server).vcpus }
    end

    def total_instances_used
      compute_servers.size
    end

    def total_ram_size_used
      compute_servers.inject(0) { |total, server| total + flavor_for_server(server).ram }
    end

    def total_volume_size_used
      @total_volume_size_used ||= volumes.inject(0) {|size, vol| size + vol.size }
    end

    def total_volumes_used
      @total_volumes_used ||= volumes.size
    end

    def volumes_limits_available?
      max_total_volume_size
    end

    def cores_available
      max_total_cores - total_cores_used
    end

    def instances_available
      max_total_instances - total_instances_used
    end

    def ram_size_available
      max_total_ram_size - total_ram_size_used
    end

    def volume_size_available
      max_total_volume_size ? (max_total_volume_size - total_volume_size_used) : nil
    end

    def volumes_available
      max_total_volumes ? (max_total_volumes - total_volumes_used) : nil
    end

    def compute_servers
      @compute_servers ||= fog_compute.servers
    end

    def volumes
      @volumes ||= fog_volumes.volumes
    end

    def flavor_for_server(server)
      fog_compute.flavors.get(server.flavor["id"])
    end

    # {
    #   "metadata_items"=>128,
    #   "ram"=>204800,
    #   "floating_ips"=>10,
    #   "key_pairs"=>100,
    #   "instances"=>40,
    #   "security_group_rules"=>20,
    #   "injected_files"=>5,
    #   "cores"=>50,
    #   "fixed_ips"=>-1,
    #   "security_groups"=>10
    # }
    def compute_quotas
      @compute_quotas ||= fog_compute.get_quota(current_tenant_id).data[:body]["quota_set"]
    end

    # {
    #   "snapshots"=>10,
    #   "gigabytes"=>15000,
    #   "volumes"=>40,
    # }
    def volume_quotas
      @volume_quotas ||= fog_volumes.get_quota(current_tenant_id).data[:body]["quota_set"]
    rescue Fog::Compute::OpenStack::NotFound
      @volume_quotas = {
        "snapshots"=>nil,
        "gigabytes"=>nil,
        "volumes"=>nil,
      }
    end

    def current_tenant_id
      fog_compute.current_tenant["id"]
    end

  end
end
