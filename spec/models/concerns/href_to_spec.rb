require 'spec_helper'

describe HrefTo do
  subject { FactoryGirl.build(:question) }

  context "#href_to" do
    def link(repr, rel)
      repr["links"].select do |link|
        link['rel'] == rel
      end.first["href"]
    end

    it "should return the link" do
      subject.href_to("self_link").should == \
        link(subject.representation, 'self_link')
    end

    it "should return nil when there isn't #representation" do
      subject.representation = nil
      subject.href_to("self_link").should be_nil
    end

    it "should return nil if there isn't link with the specified relation" do
      subject.href_to("lorem").should be_nil
    end
  end
end
