require "ohboshwillitfit"

module Bosh::Cli::Command
  class WillItFit < Base

    usage "will it fit"
    desc  "check if this deployment will fit into OpenStack tenancy"
    option "--fog-key default", "Look up credentials in ~/.fog"
    def will_it_fit
      if fog_key = options[:fog_key]
        credentials = OhBoshWillItFit::FogCredentials.load_from_file(fog_key)
      end
      p credentials
    end

  end
end
