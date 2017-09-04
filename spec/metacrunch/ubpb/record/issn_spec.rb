require "metacrunch/ubpb/record/issn"

describe Metacrunch::UBPB::Record::ISSN do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="599" ind1="a" ind2="1">
          <subfield code="a">0023-5423</subfield>
        </datafield>
        <datafield tag="599" ind1="b" ind2="1">
          <subfield code="a">0-87849-671-8</subfield>
        </datafield>
      xml
    end
    let(:issn) { described_class.new(document.datafields.first) }

    subject { issn.get }

    it { is_expected.to eq("0023-5423") }

    context "if a \"formal falsche\" ISSN was given" do
      let(:issn) { described_class.new(document.datafields.to_a.last) }

      it { is_expected.to eq("0-87849-671-8") }
    end
  end
end
