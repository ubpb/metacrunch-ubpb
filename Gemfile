source "https://rubygems.org"

gemspec

gem "metacrunch-mab2", "~> 1.3.2", github: "ubpb/metacrunch-marcxml", branch: 'v1.3'

group :development do
  gem "bundler",      ">= 1.7"
  gem "rake",         ">= 11.1"
  gem "rspec",        ">= 3.0.0",  "< 4.0.0"
  gem "simplecov",    ">= 0.11.0"
  gem "ruby-oci8",    "~> 2.0"
  gem "sequel",       "~> 5.5"
  gem "rexml",        "~> 3.2"

  if !ENV["CI"]
    gem "pry-byebug", ">= 3.5.0"
  end
end

group :test do
  gem "codeclimate-test-reporter", ">= 0.5.0", require: nil
end
