require "ohboshwillitfit"

module Bosh::Cli::Command
  class WillItFit < Base

    usage "will it fit"
    desc  "check if this deployment will fit into OpenStack tenancy"
    option "--fog-key default", "Look up credentials in ~/.fog"
    option "--ignore-invalid-flavors", "Do not fail if invalid flavors being used"
    def will_it_fit
      deployment_required
      ignore_invalid_flavors = options[:ignore_invalid_flavors]

      if fog_key = options[:fog_key]
        credentials = OhBoshWillItFit::FogCredentials.load_from_file(fog_key)
      end
      fog_compute = Fog::Compute.new({provider: 'OpenStack'}.merge(credentials))
      limits = OhBoshWillItFit::Limits.new(fog_compute)
      unless limits.limits_available?
        say "Older OpenStacks like this do not provide current resources being used.".make_yellow
        say "Can only display output based on quotas, rather than unused limits."
      end

      flavors = fog_compute.flavors
      flavor_errors = false

      resources = OhBoshWillItFit::Resource.from_file(deployment)
      OhBoshWillItFit::Resource.map_flavors!(resources, flavors)

      say ""
      say "Flavours used:"
      resources.each do |resource|
        if resource.error
          say "  #{resource.instance_type}: #{resource.error}".make_red
          flavor_errors = true
        else
          say "  #{resource.instance_type}: #{resource.size} (ram: #{resource.ram} disk: #{resource.disk} cpus: #{resource.cpus})"
        end
      end

      say ""
      if flavor_errors
        say "Available flavors:".make_yellow
        flavors.sort {|f1, f2| f1.ram <=> f2.ram}.each do |flavor|
          say "  #{flavor.name}: ram: #{flavor.ram} disk: #{flavor.disk} cpus: #{flavor.vcpus}"
        end
      end

      if !flavor_errors || ignore_invalid_flavors
        say "Resources used:"
        resource_totals = OhBoshWillItFit::Resource.resource_totals(resources)
        display_resource "ram", resource_totals["ram"], limits.ram_size_available
        display_resource "disk", resource_totals["disk"]
        display_resource "cpus", resource_totals["cpus"], limits.cores_available
      end
    rescue => e
      err e.message
    end

    private
    def display_resource(label, total, max_total=nil)
      if max_total
        message = "  #{label}: #{total} / #{max_total}"
        message = total <= max_total ? message.make_green : message.make_red
      else
        message = "  #{label}: #{total}"
      end
      say message
    end
  end
end
