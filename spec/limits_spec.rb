require "json"
require "fog/openstack/models/compute/flavor"
require "fog/openstack/models/compute/flavors"
require "fog/openstack/models/compute/server"

describe OhBoshWillItFit::Limits do
  # context "fog_limits - no_totals" do
  #   let(:fog_limits) { JSON.parse(File.read(spec_asset("fog_limits_no_totals.json"))) }
  #   let(:get_limits) { instance_double("Excon::Response", data: { body: fog_limits} ) }
  #   let(:fog_compute) { instance_double("Fog::Compute::OpenStack::Real", get_limits: get_limits) }
  #   subject { OhBoshWillItFit::Limits.new(fog_compute) }
  #   it {
  #     expect(subject.max_total_cores).to eq(1000)
  #   }
  #   it {
  #     expect(subject.max_total_instances).to eq(100)
  #   }
  #   it {
  #     expect(subject.max_total_ram_size).to eq(1966080)
  #   }
  #   it {
  #     expect(subject.total_cores_used).to eq(nil)
  #   }
  #   it {
  #     expect(subject.total_instances_used).to eq(nil)
  #   }
  #   it {
  #     expect(subject.total_ram_size_used).to eq(nil)
  #   }
  #
  #   it {
  #     expect(subject.limits_available?).to be_false
  #   }
  #
  #   it {
  #     expect(subject.cores_available).to eq(1000)
  #   }
  #   it {
  #     expect(subject.instances_available).to eq(100)
  #   }
  #   it {
  #     expect(subject.ram_size_available).to eq(1966080)
  #   }
  # end

  context "quotas - grizzly" do
    let(:tenant) do { "id" => "tenant-id" } end
    let(:servers) do
      [
        instance_double("Fog::Compute::OpenStack::Server", flavor: {"id" => "2"}),
        instance_double("Fog::Compute::OpenStack::Server", flavor: {"id" => "3"})
      ]
    end

    let(:small_flavor) { instance_double("Fog::Compute::OpenStack::Flavor", id: "2", ram: 2048, disk: 50, vcpus: 2) }
    let(:medium_flavor) { instance_double("Fog::Compute::OpenStack::Flavor", id: "3", ram: 4096, disk: 50, vcpus: 1) }
    let(:flavors) { instance_double("Fog::Compute::OpenStack::Flavors") }
    before do
      flavors.stub(:get).with("2").and_return(small_flavor)
      flavors.stub(:get).with("3").and_return(medium_flavor)
    end

    let(:compute_quotas) { JSON.parse(File.read(spec_asset("quotas_compute.json"))) }
    let(:compute_get_quota) { instance_double("Excon::Response", data: { body: compute_quotas } ) }
    let(:fog_compute) {
      instance_double("Fog::Compute::OpenStack::Real",
        servers: servers,
        flavors: flavors,
        get_quota: compute_get_quota,
        current_tenant: tenant)
    }

    let(:volumes_quotas) { JSON.parse(File.read(spec_asset("quotas_volumes.json"))) }
    let(:volumes_get_quota) { instance_double("Excon::Response", data: { body: volumes_quotas} ) }
    let(:fog_volumes) { instance_double("Fog::Volume::OpenStack::Real", get_quota: volumes_get_quota) }

    subject { OhBoshWillItFit::Limits.new(fog_compute, fog_volumes) }

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
      expect(subject.total_cores_used).to eq(3)
    }
    it {
      expect(subject.total_instances_used).to eq(2)
    }
    it {
      expect(subject.total_ram_size_used).to eq(6144)
    }

    it {
      expect(subject.limits_available?).to be_true
    }

    it {
      expect(subject.cores_available).to eq(50-3)
    }
    it {
      expect(subject.instances_available).to eq(40-2)
    }
    it {
      expect(subject.ram_size_available).to eq(204800-6144)
    }
  end

end
