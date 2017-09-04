require "metacrunch/ubpb/record/erweiterter_datenträgertyp"

describe Metacrunch::UBPB::Record::ErweiterterDatenträgertyp do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="064" ind1="b" ind2="1">
          <subfield code="a">CD-ROM</subfield>
          <subfield code="9">(DE-588)4139307-7</subfield>
        </datafield>
      xml
    end
    let(:element) { described_class.new(document.datafields.first) }

    subject { element.get }

    it { is_expected.to eq("CD-ROM") }
  end
end
