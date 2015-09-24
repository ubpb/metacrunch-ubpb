source "https://rubygems.org"

gemspec

group :development do
  gem "bundler"
  gem "rake"
  gem "rspec",     ">= 3.0.0",  "< 4.0.0"
  gem "simplecov", ">= 0.8.0"

  if !ENV["CI"]
    gem "hashdiff"
    gem "pry",                "~> 0.9.12.6"
    gem "pry-byebug",         "<= 1.3.2"
    gem "pry-rescue",         "~> 1.4.2"
    gem "pry-stack_explorer", "~> 0.4.9.1"
    gem "pry-syntax-hacks",   "~> 0.0.6"
  end
end

group :test do
  gem "codeclimate-test-reporter", require: nil
end

gem "metacrunch",               ">= 2.1.0", github: "ubpb/metacrunch",      branch: "master"
gem "metacrunch-mab2",          ">= 1.0.0", github: "ubpb/metacrunch-mab2", branch: "master"
gem "metacrunch-elasticsearch", ">= 1.0.0", github: "ubpb/metacrunch-elasticsearch", branch: "master"
