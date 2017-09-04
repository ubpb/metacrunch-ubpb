require "metacrunch/ubpb/record/angabe_zum_inhalt"

describe Metacrunch::UBPB::Record::AngabeZumInhalt do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="521" ind1="-" ind2="1">
          <subfield code="p">Enthält:</subfield>
          <subfield code="t">&lt;&lt;Das&gt;&gt; Jungfernöl</subfield>
          <subfield code="r">Margaret Mead</subfield>
        </datafield>
      xml
    end
    let(:element) { described_class.new(document.datafields.first) }

    subject { element.get }

    it { is_expected.to be_an(String) }
    it { is_expected.to eq("Enthält: Das Jungfernöl") }

    context "if \"Titel\" was given" do
      subject { element.get("Titel") }

      it { is_expected.to be_an(String) }
      it { is_expected.to eq("Das Jungfernöl") }
    end
  end
end
