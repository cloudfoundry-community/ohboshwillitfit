module OhBoshWillItFit
  class FogCredentials
    def self.load_from_file(fog_key, fog_file="~/.fog")
      fog_file = File.expand_path(fog_file)
      return nil unless File.exists?(fog_file)
      credentials = YAML.load_file(fog_file)
      credentials[fog_key.to_sym] || credentials[fog_key.to_s]
    end
  end
end
