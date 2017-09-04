#!/usr/bin/env ruby
require "bundler/setup"
require "metacrunch/ubpb"

require "open-uri"
require "rexml/document"
begin require "pry" rescue LoadError ; end

record_id      = ARGV[0]
aleph_base_url = ENV["ALEPH_BASE_URL"] || "http://ubex.uni-paderborn.de:1891"
url            = "#{aleph_base_url}/rest-dlf/record/PAD01#{record_id}?view=full"
data           = nil
mab2primo      = Metacrunch::UBPB::Transformations::MabToPrimo.new
primo2es       = Metacrunch::UBPB::Transformations::PrimoToElasticsearch.new

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

open(url) { |io| data = io.read }

result = mab2primo.call(data)
decode_json!(result)
result = primo2es.call(result)

REXML::Document.new(data).write($stdout, 2)
puts "\n----------------------------------"
puts JSON.pretty_generate(result)
