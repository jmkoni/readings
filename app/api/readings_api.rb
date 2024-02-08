class ReadingsApi < Sinatra::Base
  # root path describes available endpoints
  get "/" do
    "<h1>Welcome to the Readings API!</h1>\n\nAvailable endpoints:\n\n<ul><li>GET /latest/:id\n</li><li>GET /cumulative/:id\n</li><li>POST /readings\n</li></ul>"
  end

  # get latest timestamp for a device
  get "/latest/:id", provides: :json do
    {latest_timestamp: Device.latest(params["id"])}.to_json
  end

  # get cumulative count for a device
  get "/cumulative/:id", provides: :json do
    {cumulative_count: Device.cumulative(params["id"])}.to_json
  end

  # create a new reading for a device
  post "/readings", provides: :json do
    data = JSON.parse request.body.read.gsub("=>", ":")
    result = Device.create(data)
    if result
      status 201
      message = {message: "Reading created"}.to_json
    else
      status 400
      message = {message: "Reading not created"}.to_json
    end
    body { message }
  end
end
