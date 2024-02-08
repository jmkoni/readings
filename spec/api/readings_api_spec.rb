require "spec_helper"

RSpec.describe ReadingsApi do
  def app
    ReadingsApi
  end

  describe "GET /" do
    it "returns hello world" do
      get "/"
      expected_response = "<h1>Welcome to the Readings API!</h1>\n\nAvailable endpoints:\n\n<ul><li>GET /latest/:id\n</li><li>GET /cumulative/:id\n</li><li>POST /readings\n</li></ul>"
      expect(last_response).to be_ok
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe "GET /latest/:id" do
    it "returns the latest timestamp for the device" do
      Device.create({"id" => "123", "readings" => [{"timestamp" => "2018-01-01T00:00:00Z", "count" => 1}]})
      get "/latest/123"
      expect(last_response).to be_ok
      expect(last_response.body).to eq({latest_timestamp: Time.new("2018-01-01T00:00:00Z")}.to_json)
    end
  end

  describe "GET /cumulative/:id" do
    it "returns the cumulative count for the device" do
      Device.create({"id" => "123", "readings" => [{"timestamp" => "2018-01-01T00:00:00Z", "count" => 1}]})
      get "/cumulative/123"
      expect(last_response).to be_ok
      expect(last_response.body).to eq({cumulative_count: 1}.to_json)
    end
  end

  describe "POST /readings" do
    it "creates a new reading for the device" do
      data = {"id" => "123", "readings" => [{"timestamp" => "2018-01-01T00:00:00Z", "count" => 1}]}
      post "/readings", data.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response).to be_created
      expect(last_response.body).to eq({message: "Reading created"}.to_json)
    end

    it "returns an error if the reading is not created" do
      data = {"id" => "123", "readings" => [{"timestamp" => "2018-01-01T00:00:00Z", "count" => "one"}]}
      post "/readings", data.to_json, "CONTENT_TYPE" => "application/json"
      expect(last_response).to be_bad_request
      expect(last_response.body).to eq({message: "Reading not created"}.to_json)
    end
  end
end
