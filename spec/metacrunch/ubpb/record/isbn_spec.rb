require "metacrunch/ubpb/record/isbn"

describe Metacrunch::UBPB::Record::ISBN do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="540" ind1="-" ind2="1">
          <subfield code="a">9781610691191</subfield>
        </datafield>
        <datafield tag="540" ind1="z" ind2="1">
          <subfield code="b">Gewebe : Rbl 10.50</subfield>
        </datafield>
      xml
    end
    let(:isbn) { described_class.new(document.datafields.first) }

    subject { isbn.get }

    it { is_expected.to eq(isbn.get("ISBN ohne Textzusätze")) }

    context "if \"Einbandart und Preis\" was given" do
      let(:isbn) { described_class.new(document.datafields.to_a.last) }
      subject { isbn.get("Einbandart und Preis") }

      it {is_expected.to eq("Gewebe : Rbl 10.50") }
    end

    context "if \"ISBN ohne Textzusätze\" was given" do
      let(:isbn) { described_class.new(document.datafields.first) }
      subject { isbn.get("ISBN ohne Textzusätze") }

      it {is_expected.to eq("9781610691191") }
    end
  end
end
