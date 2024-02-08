require "spec_helper"

RSpec.describe Device do
  let(:data) { {"id" => "123", "readings" => [{"timestamp" => "2014-05-07T18:00:00+02:00", "count" => 100}, {"timestamp" => "2020-06-08T15:00:02+01:00", "count" => 15}]} }

  describe ".latest" do
    it "returns the latest reading for a device" do
      Device.create(data)
      expect(Device.latest("123")).to eq(Time.new("2020-06-08T15:00:02+01:00"))
    end
  end

  describe ".cumulative" do
    it "returns the cumulative count for a device" do
      Device.create(data)
      expect(Device.cumulative("123")).to eq(115)
    end
  end

  describe ".create" do
    it "creates a reading for a device" do
      expect(Device.create(data)).to be true
    end

    it "returns false if a reading is not created because count is invalid" do
      data = {"id" => "123", "readings" => [{"timestamp" => "2014-05-07T18:00:00+02:00", "count" => "one"}]}
      expect(Device.create(data)).to be false
    end

    it "returns false if a reading is not created because timestamp is invalid time" do
      data = {"id" => "123", "readings" => [{"timestamp" => "12934871-12-123-125", "count" => 100}]}
      expect(Device.create(data)).to be false
    end

    it "returns false if a reading is not created because timestamp is in the future" do
      time = (Time.now + (60 * 60 * 24 * 365)).strftime("%Y-%m-%dT%H:%M:%S%:z")
      data = {"id" => "123", "readings" => [{"timestamp" => time, "count" => 100}]}
      expect(Device.create(data)).to be false
    end

    it "returns false if reading is already present for a given timestamp" do
      expect(Device.create(data)).to be true
      data_with_repeat_timestamp = {"id" => "123", "readings" => [{"timestamp" => "2014-05-07T18:00:00+02:00", "count" => 200}]}
      expect(Device.create(data_with_repeat_timestamp)).to be false
    end
  end
end
