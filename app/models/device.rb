class Device
  class << self
    def latest(id)
      $db[id] ||= [] # initialize empty array if no readings
      # because we sort the timestamps in the create method, we can just return the last one
      $db[id].empty? ? nil : $db[id].last[:timestamp]
    end

    def cumulative(id)
      $db[id] ||= [] # initialize empty array if no readings
      count = 0
      return count if $db[id].empty?
      # sum all reading counts
      $db[id].map { |reading| count += reading[:count] }
      count
    end

    def create(data)
      # first, validate that data includes an id
      return false unless data["id"]
      $db[data["id"]] ||= [] # initialize empty array if no readings
      success = false # flag to track if any readings are created
      data["readings"].each do |reading|
        timestamp = validate_time(reading["timestamp"])
        count = set_count(reading["count"])
        next unless timestamp && count # validate that both are present and valid
        next unless $db[data["id"]].select { |current_reading| current_reading[:timestamp] == timestamp }.empty?
        $db[data["id"]] << {timestamp: timestamp, count: count}
        success = true
      end
      return false unless success

      # sort readings by timestamp
      $db[data["id"]].sort_by! { |reading| reading[:timestamp] }
      true
    end

    private

    # validate that timestamp is a valid time and not in the future
    def validate_time(timestamp)
      time = Time.new(timestamp)
      return nil if time.year > Time.now.year # only allow past and present times
      time
    rescue
      nil
    end

    # validate that count is a valid number. accepts either string ("3") or integer (3)
    def set_count(count)
      (count.to_s.to_i == count) ? count.to_i : nil
    end
  end
end
