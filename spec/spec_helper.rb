# Copyright (c) 2012-2013 Stark & Wayne, LLC

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

$:.unshift(File.expand_path("../../lib", __FILE__))

require "rspec/core"
require "ohboshwillitfit"

# for the #sh helper
require "rake"
require "rake/file_utils"

# load all files in spec/support/* (but not lower down)
Dir[File.dirname(__FILE__) + '/support/*'].each do |path|
  require path unless File.directory?(path)
end

def setup_fog_with_various_accounts_setup
  File.open(File.expand_path("~/.fog"), "w") do |f|
    f << {
      default: {
        openstack_username: "USERNAME",
        openstack_api_key: "PASSWORD",
        openstack_tenant: "TENANT",
        openstack_auth_url: "URL"
      },
    }.to_yaml
  end
end

def spec_asset(filename)
  File.expand_path("../assets/#{filename}", __FILE__)
end

def setup_home_dir
  home_dir = File.expand_path("../../tmp/home", __FILE__)
  FileUtils.rm_rf(home_dir)
  FileUtils.mkdir_p(home_dir)
  ENV['HOME'] = home_dir
end

def setup_path
  ENV['PATH'] = File.expand_path("../../bin", __FILE__) + ":" + ENV['PATH']
end
# returns the file path to a file
# in the fake $HOME folder
def home_file(*path)
  File.join(ENV['HOME'], *path)
end

RSpec.configure do |c|
  c.before do
    setup_home_dir
    setup_path
  end

  c.color_enabled = true
end
