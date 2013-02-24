require 'spec_helper'

describe Gitlab::API do
  include ApiHelpers

  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let!(:project) { create(:project, namespace: user.namespace) }
  let!(:group1) { create(:group, owner: user) }
  let!(:group2) { create(:group, owner: admin) }
  before { project.team << [user, :reporter] }

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

    context "as administrator" do
      it "should return an array of namespaces" do
        get api("/namespaces", admin)
        response.status.should == 200
        json_response.should be_an Array
      end

      it "should contain two entries" do
        get api("/namespaces", admin)
        json_response.length.should == 2
      end

      it "should include group name in namespaces" do
        get api("/namespaces", admin)
        json_response[0]['id'].should == admin.namespace_id
        json_response[1]['id'].should == group2.id
      end
    end
  end

  describe "GET /namespaces/:id" do
    context "when unauthenticated" do
      it "should return a 401 unauthorized error" do
        get api("/namespaces/#{project.namespace_id}")
        response.status.should == 401
      end
    end

    context "when authenticated" do
      it "should return the namespace" do
        get api("/namespaces/#{project.namespace_id}", user)
        response.status.should == 200
        json_response['id'].should == project.namespace_id
      end
    end

    it "should return 404 error if namespace id not found" do
      get api("/namespaces/123456", user)
      response.status.should == 404
    end
  end
end