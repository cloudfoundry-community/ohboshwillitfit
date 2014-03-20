# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ohboshwillitfit/version'

Gem::Specification.new do |spec|
  spec.name          = "OhBoshWillItFit"
  spec.version       = OhBoshWillItFit::VERSION
  spec.authors       = ["Dr Nic Williams"]
  spec.email         = ["drnicwilliams@gmail.com"]
  spec.summary       = %q{Will this OpenStack BOSH deployment fit or not? If not, fail fast.}
  spec.description   = <<-EOS
  Lives have been wasted waiting for a BOSH deployment to run only to find that you
  don't have a quota large enough. Not enough instances, CPU, RAM, disk or volumes. OMG.
  Run this BOSH CLI plugin first to find out if it will fit. Fail fast.
  EOS
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
