require "fog/openstack/models/compute/flavor"

describe OhBoshWillItFit::Resource do
  let(:flavors) do
    [
      instance_double("Fog::Compute::OpenStack::Flavor", name: "m1.small", ram: 2048, disk: 12, vcpus: 1),
      instance_double("Fog::Compute::OpenStack::Flavor", name: "m1.xlarge", ram: 16384, disk: 80, vcpus: 8)
    ]
  end

  context "small deployment that will fit" do
    let(:deployment_file) { spec_asset("deployment-small.yml") }
    subject { OhBoshWillItFit::Resource.from_file(deployment_file) }
    it { expect(subject.size).to eq(1) }
    it { expect(subject.first.instance_type).to eq("m1.small") }
    it { expect(subject.first.size).to eq(2) }

    context "with flavors" do
      before do
        OhBoshWillItFit::Resource.map_flavors!(subject, flavors)
      end
      it { expect(subject.first.ram).to eq(2048) }
      it { expect(subject.first.total_ram).to eq(4096) }
      it { expect(subject.first.disk).to eq(12) }
      it { expect(subject.first.total_disk).to eq(24) }
      it { expect(subject.first.cpus).to eq(1) }
      it { expect(subject.first.total_cpus).to eq(2) }
      it {
        totals = OhBoshWillItFit::Resource.resource_totals(subject)
        expect(totals).to eq({"ram" => 4096, "disk" => 24, "cpus" => 2})
      }
    end
  end

  context "small deployment that won't fit" do
    let(:deployment_file) { spec_asset("deployment-wontfit.yml") }
    subject { OhBoshWillItFit::Resource.from_file(deployment_file) }
    it { expect(subject.size).to eq(1) }
    it { expect(subject.first.instance_type).to eq("m1.xlarge") }
    it { expect(subject.first.size).to eq(50) }

    context "with flavors" do
      before do
        OhBoshWillItFit::Resource.map_flavors!(subject, flavors)
      end
      it { expect(subject.first.ram).to eq(16384) }
      it { expect(subject.first.total_ram).to eq(50 * 16384) }
      it { expect(subject.first.disk).to eq(80) }
      it { expect(subject.first.total_disk).to eq(50 * 80) }
      it { expect(subject.first.cpus).to eq(8) }
      it { expect(subject.first.total_cpus).to eq(50 * 8) }
      it {
        totals = OhBoshWillItFit::Resource.resource_totals(subject)
        expect(totals).to eq({"ram" => 50 * 16384, "disk" => 50 * 80, "cpus" => 50 * 8})
      }
    end
  end

end
