require "spec_helper"

describe Gitlab::API do
  include ApiHelpers

  let(:user) { create(:user ) }
  let!(:project) { create(:project, namespace: user.namespace ) }
  let!(:merge_request) { create(:merge_request, author: user, assignee: user, project: project, title: "Test") }
  before { project.team << [user, :reporters] }

  describe "GET /projects/:id/merge_requests" do
    context "when unauthenticated" do
      it "should return authentication error" do
        get api("/projects/#{project.id}/merge_requests")
        response.status.should == 401
      end
    end

    context "when authenticated" do
      it "should return an array of merge_requests" do
        get api("/projects/#{project.id}/merge_requests", user)
        response.status.should == 200
        json_response.should be_an Array
        json_response.first['title'].should == merge_request.title
      end
    end
  end

  describe "GET /projects/:id/merge_request/:merge_request_id" do
    it "should return merge_request" do
      get api("/projects/#{project.id}/merge_request/#{merge_request.id}", user)
      response.status.should == 200
      json_response['title'].should == merge_request.title
    end
  end

  describe "POST /projects/:id/merge_requests" do
    it "should return merge_request" do
      post api("/projects/#{project.id}/merge_requests", user),
        title: 'Test merge_request', source_branch: "stable", target_branch: "master", author: user
      response.status.should == 201
      json_response['title'].should == 'Test merge_request'
    end

    it "should return 422 when source_branch does not exist" do
      post api("/projects/#{project.id}/merge_requests", user),
        title: "Test", source_branch: "should_not_be_available", target_branch: "master", author: user
      response.status.should == 422
    end

    it "should return 422 when target_branch does not exist" do
      post api("/projects/#{project.id}/merge_requests", user),
        title: "Test", source_branch: "stable", target_branch: "should_not_be_available", author: user
      response.status.should == 422
    end
  end

  describe "PUT /projects/:id/merge_request/:merge_request_id" do
    it "should return merge_request" do
      put api("/projects/#{project.id}/merge_request/#{merge_request.id}", user), title: "New title"
      response.status.should == 200
      json_response['title'].should == 'New title'
    end

    it "should return 422 when renaming target_branch to non existing branch" do
      put api("/projects/#{project.id}/merge_request/#{merge_request.id}", user), target_branch: "unknown"
      response.status.should == 422
    end

    it "should return 422 when renaming source_branch to non existing branch" do
      put api("/projects/#{project.id}/merge_request/#{merge_request.id}", user), source_branch: "unknown"
      response.status.should == 422
    end
  end

  describe "POST /projects/:id/merge_request/:merge_request_id/comments" do
    it "should return comment" do
      post api("/projects/#{project.id}/merge_request/#{merge_request.id}/comments", user), note: "My comment"
      response.status.should == 201
      json_response['note'].should == 'My comment'
    end
  end

end
