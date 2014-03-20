describe OhBoshWillItFit::Resources do
  context "small deployment that will fit" do
    let(:deployment_file) { spec_asset("deployment-small.yml") }
    subject { OhBoshWillItFit::Resources.new(deployment_file) }
    it {
      expect(subject.resources).to eq({ "m1.small" => { "size" => 2 } })
    }
  end

  context "small deployment that won't fit" do
    let(:deployment_file) { spec_asset("deployment-wontfit.yml") }
    subject { OhBoshWillItFit::Resources.new(deployment_file) }
    it {
      expect(subject.resources).to eq({ "m1.xlarge" => { "size" => 50 } })
    }
  end

end
