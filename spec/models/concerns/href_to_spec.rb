require 'spec_helper'

describe HrefTo do
  subject { Question.new }
  context "#href_to" do
    let(:url) { "http://www.redu.com.br/espacos/2231/modulos/3248/aulas/5154-q3" }
    let(:repr) do
      { "links"=>[{"href"=> url , "rel"=>"self_link"}]}
    end

    it "should return the link" do
      subject.representation = repr
      subject.href_to("self_link").should == url
    end

    it "should return nil when there isn't #representation" do
      subject.href_to("self_link").should be_nil
    end

    it "should return nil if there isn't link with the specified relation" do
      subject.representation = repr
      subject.href_to("space").should be_nil
    end
  end
end
