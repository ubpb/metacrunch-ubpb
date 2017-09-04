require "metacrunch/ubpb/record/generisches_element"

describe Metacrunch::UBPB::Record::GenerischesElement do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="334" ind1="-" ind2="1">
          <subfield code="a">CD-ROM</subfield>
        </datafield>
      xml
    end
    let(:element) { described_class.new(document.datafields.first) }

    subject { element.get }

    it { is_expected.to eq("CD-ROM") }
  end
end
