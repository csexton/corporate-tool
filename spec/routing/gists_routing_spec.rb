require "rails_helper"

RSpec.describe GistsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/gists").to route_to("gists#index")
    end

    it "routes to #new" do
      expect(:get => "/gists/new").to route_to("gists#new")
    end

    it "routes to #show" do
      expect(:get => "/gists/1").to route_to("gists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/gists/1/edit").to route_to("gists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/gists").to route_to("gists#create")
    end

    it "routes to #update" do
      expect(:put => "/gists/1").to route_to("gists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/gists/1").to route_to("gists#destroy", :id => "1")
    end

  end
end
