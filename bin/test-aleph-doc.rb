#!/usr/bin/env ruby
require "bundler/setup"
require "metacrunch/ubpb"
require "sequel"
require "open-uri"
require "rexml/document"
begin require "pry" rescue LoadError ; end

logger    = Logger.new(STDOUT)
db        = Sequel.oracle("aleph22", user: "padview", password: ENV["PASSWORD"], host: "localhost", port: "1521", logger: logger)
record_id = ARGV[0]
mab2primo = Metacrunch::UBPB::Transformations::MabToPrimo.new
primo2es  = Metacrunch::UBPB::Transformations::PrimoToElasticsearch.new

def decode_json!(object)
  case object
  when Array
    object.map! do |_value|
      decode_json!(_value)
    end
  when Hash
    object.each do |_key, _value|
      object[_key] = decode_json!(_value)
    end
  when String
    if object.start_with?("{") && object.end_with?("}")
      JSON.parse(object)
    else
      object
    end
  else
    object
  end
end

if record_id =~ /\A\d{9}\z/
  dataset = db.from(Sequel[:pad50][:z00p]).where(z00p_doc_number: record_id)
  record = dataset.first
  data = record[:z00p_str].presence || record[:z00p_ptr].presence

  result = mab2primo.call(data)
  decode_json!(result)
  result = primo2es.call(result)

  REXML::Document.new(data).write($stdout, 2)
  puts "\n----------------------------------"
  puts JSON.pretty_generate(result)
else
  puts "Invalid record ID"
end

