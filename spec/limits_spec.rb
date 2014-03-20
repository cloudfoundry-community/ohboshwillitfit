require "json"

describe OhBoshWillItFit::Limits do
  let(:fog_limits) { JSON.parse(File.read(spec_asset("fog_limits.json"))) }
  let(:get_limits) { instance_double("Excon::Response", data: { body: fog_limits} ) }
  let(:fog_compute) { instance_double("Fog::Compute::OpenStack::Real", get_limits: get_limits) }
  subject { OhBoshWillItFit::Limits.new(fog_compute) }
  it {
    expect(subject.max_total_cores).to eq(1000)
  }
  it {
    expect(subject.max_total_instances).to eq(100)
  }
  it {
    expect(subject.max_total_ram_size).to eq(1966080)
  }
end
