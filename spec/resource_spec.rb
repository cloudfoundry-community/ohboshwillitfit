describe OhBoshWillItFit::Resource do
  context "small deployment that will fit" do
    let(:deployment_file) { spec_asset("deployment-small.yml") }
    subject { OhBoshWillItFit::Resource.from_file(deployment_file) }
    it { expect(subject.size).to eq(1) }
    it { expect(subject.first.instance_type).to eq("m1.small") }
    it { expect(subject.first.size).to eq(2) }
  end

  context "small deployment that won't fit" do
    let(:deployment_file) { spec_asset("deployment-wontfit.yml") }
    subject { OhBoshWillItFit::Resource.from_file(deployment_file) }
    it { expect(subject.size).to eq(1) }
    it { expect(subject.first.instance_type).to eq("m1.xlarge") }
    it { expect(subject.first.size).to eq(50) }
  end

end
