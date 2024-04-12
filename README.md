# Readings API

This is a simple test app that stores "reading" data and returns it. It uses just a simple in-memory data store. It is built with Sinatra and tested using Rspec.

## Ruby Version

3.2.2

## Running the app

You should be able to just run `bin/setup` to initialize the app and install any needed dependencies. If you are using RVM, it will use the `.ruby-gemset` and `.ruby-version` files to install the right ruby version and create a gemset for you when you enter the project directory. If you want to do it step by step:

``` sh
bundle install
puma
```

## Endpoints

### GET /cumulative/:id

Returns the cumulative count of all readings for a given device. Pass in the id of the device in the request. Example:

``` sh
http://0.0.0.0:9292/cumulative/123-456 # 123-456 is the device id
```

Example response:

``` json
{ "cumulative_count": 23 }
```

A zero will be returned if no data exists.

### GET /latest/:id

Returns the latest timestamp of all readings for a given device. Pass in the id of the device in the request. Example:

``` sh
http://0.0.0.0:9292/cumulative/123-456 # 123-456 is the device id
```

Example response:

``` json
{ "latest_timestamp": "2021-09-29T16:08:15+01:00" }
```

A nil value will returned if no data exists.

### POST /readings

Adds readings to a given device. Expected request body:

``` json
{
  "id": "36d5658a-6908-479e-887e-a949ec199272",
  "readings":
  [
    {
      "timestamp": "2021-09-29T16:08:15+01:00",
      "count": 2
    }, {
      "timestamp": "2021-09-29T16:09:15+01:00",
      "count": 15
    }
  ]
}
```

Timestamps must be ISO-8061 standard. Count is expected as an integer, but "1" will be parsed as a 1. Any duplicate timestamp is ignored.

Example response:

``` json
{ message: "Reading created" }
```
Status: 201

``` json
{ message: "Reading not created" }
```
Status: 400

## General project structure

``` sh
- app # primary application code
  - api # home for API
  - models # currently home to Device model
- config # set up environment
- spec # home to tests
  - api # request specs
  - models # model specs
```

## Running the tests

Just run `rspec`!

## Potential Improvements

- Device could be more along the lines of a traditional ActiveRecord model
  - At that point, validations could be moved to an instance instead of embedded in the create method
- Actually using a database would be useful. SQLite is probably the best option for this project
