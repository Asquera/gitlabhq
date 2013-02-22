require 'spec_helper'

describe Gitlab::API do
  include ApiHelpers

  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "GET /namespaces" do
    context "when unauthenticated" do
      it "should return a 401 unauthorized error" do
        get api("/namespaces")
        response.status.should == 401
      end
    end

    context "when authenticated" do
      it "should return an array of namespaces" do
        get api("/namespaces", user)
        response.status.should == 200
        json_response.should be_an Array
      end
    end
  end
end