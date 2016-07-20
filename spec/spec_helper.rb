if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
else
  # if RUBY_PLATFORM != "java"
  #   require "simplecov"
  #   SimpleCov.start
  # end
end

require "metacrunch/ubpb"
require "metacrunch/mab2/xml_builder"

begin
  require "pry"
rescue LoadError
end

# former spec_helper
Dir.glob(File.join(__dir__, "helpers", "**", "*.rb"), &method(:require))

RSpec.configure do |config|
  # begin --- rspec 3.1 generator
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  # end --- rspec 3.1 generator

  # former spec_helper
  config.include TransformationHelper
end


# Helper to provide RSpec.root
module ::RSpec
  module_function
  def root
    @spec_root ||= Pathname.new(__dir__)
  end
end

def asset_dir
  File.expand_path(File.join(File.dirname(__FILE__), "assets"))
end

def define_field_test(id, options = {})
  asset_directory = (described_class && described_class.to_s.split("::").last.underscore) || File.basename(location).sub(/_spec.+\Z/, "")
  mab_xml_file_name = id[/\A\d{9}\Z/] ? "PAD01.#{id}.PRIMO.xml" : "#{id}.xml"
  mab_xml_asset_path = File.join(asset_directory, mab_xml_file_name)
  transformation = options.delete(:transformation) || Metacrunch::UBPB::Transformations::MabToPrimo.new

  options.each_pair do |_key, _value|
    _key = _key.to_s

    context "for #{mab_xml_file_name}" do
      describe _key do
        subject { transformation.call(read_asset(mab_xml_asset_path))[_key] }
        it { is_expected.to eq(_value) }
      end
    end
  end
end

def mab_xml_builder(identifier="aleph-publish:000000000", &block)
  Metacrunch::Mab2::XmlBuilder.new(&block).to_xml
end

def read_asset(path_to_file)
  File.read(File.expand_path(File.join(asset_dir, path_to_file)))
end

def transformation_factory(*steps)
  Class.new(Metacrunch::UBPB::Transformations::MabToPrimo) do
    sequence steps
  end
end

def xml_factory(xml)
  <<-xml.strip_heredoc
    <?xml version="1.0" encoding="UTF-8"?>
    <OAI-PMH>
      <ListRecords>
        <record>
          <metadata>
            <record>
              #{xml}
            </record>
          </metadata>
        </record>
      </ListRecords>
    </OAI-PMH>
  xml
end
