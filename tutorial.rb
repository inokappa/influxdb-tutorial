#!/usr/bin/env ruby

require 'yaml'
require 'influxdb'

config = YAML.load(File.read("config.yml"))

database = config['dbname']
name     = config['name']

# Create InfluxDB Client
influxdb = InfluxDB::Client.new database,
                                host: config['host'],
                                username: config['username'],
                                password: config['password'],
                                use_ssl: true

# Create Database
databases = []
influxdb.list_databases.each { |db| databases << db.values}
if databases.flatten.include?(database)
  puts "Database exsits."
else
  print "Database does not exsits.\nCreate Database.\n"
  influxdb.create_database(database)
end

# Write Point
loop do
  data = {
    values: { value: rand(1..1000) },
    tags: { foo: "bar" }
  }

  p data
  influxdb.write_point(name, data)

  sleep 1
end
