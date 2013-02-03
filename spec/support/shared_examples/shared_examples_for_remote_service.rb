shared_examples "a remote service" do
  it "should have a #client" do
    subject.client.should be_a Redu::Client
  end

  it "should have a #resource" do
    subject.resource.should_not be_nil
  end
end

