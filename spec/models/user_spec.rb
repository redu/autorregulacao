require 'spec_helper'

describe User do
  context "relations" do
    %w(ar_exercises answers cooperations).each do |rel|
      it { should have_many(rel.to_sym).dependent(:destroy) }
    end
  end
end
