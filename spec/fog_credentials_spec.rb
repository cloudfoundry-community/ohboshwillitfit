describe OhBoshWillItFit::FogCredentials do
  it "load_from_file for valid key" do
    setup_fog_with_various_accounts_setup
    expected = {
      openstack_username: "USERNAME",
      openstack_api_key: "PASSWORD",
      openstack_tenant: "TENANT",
      openstack_auth_url: "URL"
    }
    expect(OhBoshWillItFit::FogCredentials.load_from_file("default")).to eq(expected)
  end

  it "load_from_file for unknown key" do
    setup_fog_with_various_accounts_setup
    expect(OhBoshWillItFit::FogCredentials.load_from_file("xxx")).to be_nil
  end

  it ".fog doesn't exist" do
    expect(OhBoshWillItFit::FogCredentials.load_from_file("default")).to be_nil
  end
end
