
shared_examples "a form" do
  it "should #persist! if valid" do
    subject.stub(:valid?).and_return(true)
    subject.should_receive(:persist!)
    subject.save
  end

  it "should not receive persist if invalid" do
    subject.stub(:valid?).and_return(false)
    subject.should_not_receive(:persist!)
    subject.save
  end

  it "should return true when successful" do
    subject.stub(:persist!)
    subject.stub(:valid?).and_return(true)
    subject.save.should be
  end

  it "should return false when not successful" do
    subject.stub(:valid?).and_return(false)
    subject.save.should_not be
  end

end
