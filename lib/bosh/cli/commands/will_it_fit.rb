require "ohboshwillitfit"

module Bosh::Cli::Command
  class WillItFit < Base

    usage "will it fit"
    desc  "check if this deployment will fit into OpenStack tenancy"
    option "--fog-key default", "Look up credentials in ~/.fog"
    def will_it_fit
      deployment_required

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

      resources = OhBoshWillItFit::Resources.new(deployment).resources_from_flavors(flavors)

      say ""
      say "Resources used:"
      resources.each do |instance_type, resource|
        say "  #{instance_type}: #{resource['size']}"
      end
    rescue => e
      err e.message
    end

  end
end
