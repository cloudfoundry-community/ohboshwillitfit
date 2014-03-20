require "json"

describe OhBoshWillItFit::Limits do
  context "fog_limits - no_totals" do
    let(:fog_limits) { JSON.parse(File.read(spec_asset("fog_limits_no_totals.json"))) }
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
    it {
      expect(subject.total_cores_used).to eq(nil)
    }
    it {
      expect(subject.total_instances_used).to eq(nil)
    }
    it {
      expect(subject.total_ram_size_used).to eq(nil)
    }

    it {
      expect(subject.limits_available?).to be_false
    }

    it {
      expect(subject.cores_available).to eq(1000)
    }
    it {
      expect(subject.instances_available).to eq(100)
    }
    it {
      expect(subject.ram_size_available).to eq(1966080)
    }
  end

  context "fog_limits - totals" do
    let(:fog_limits) { JSON.parse(File.read(spec_asset("fog_limits_totals.json"))) }
    let(:get_limits) { instance_double("Excon::Response", data: { body: fog_limits} ) }
    let(:fog_compute) { instance_double("Fog::Compute::OpenStack::Real", get_limits: get_limits) }
    subject { OhBoshWillItFit::Limits.new(fog_compute) }
    it {
      expect(subject.max_total_cores).to eq(50)
    }
    it {
      expect(subject.max_total_instances).to eq(40)
    }
    it {
      expect(subject.max_total_ram_size).to eq(204800)
    }
    it {
      expect(subject.total_cores_used).to eq(43)
    }
    it {
      expect(subject.total_instances_used).to eq(24)
    }
    it {
      expect(subject.total_ram_size_used).to eq(169472)
    }

    it {
      expect(subject.limits_available?).to be_true
    }

    it {
      expect(subject.cores_available).to eq(50-43)
    }
    it {
      expect(subject.instances_available).to eq(40-24)
    }
    it {
      expect(subject.ram_size_available).to eq(204800-169472)
    }
  end

end
