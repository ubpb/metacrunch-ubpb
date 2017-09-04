require "metacrunch/ubpb/record/art_des_inhalts"

describe Metacrunch::UBPB::Record::ArtDesInhalts do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="064" ind1="a" ind2="1">
          <subfield code="a">Zeitschrift</subfield>
          <subfield code="x">Landesmuseum</subfield>
          <subfield code="z">Köln</subfield>
          <subfield code="y">2015</subfield>
          <subfield code="9">(DE-588)4067488-5</subfield>
        </datafield>
      xml
    end
    let(:element) { described_class.new(document.datafields.first) }

    subject { element.get }

    it { is_expected.to be_an(String) }
    it { is_expected.to eq("Zeitschrift") }

    context "if \"allgemeine Unterteilung\" was given" do
      subject { element.get("allgemeine Unterteilung") }

      it { is_expected.to be_an(Array) }
      it { is_expected.to eq(["Landesmuseum"]) }
    end

    context "if \"geografische Unterteilung\" was given" do
      subject { element.get("geografische Unterteilung") }

      it { is_expected.to be_an(Array) }
      it { is_expected.to eq(["Köln"]) }
    end

    context "if \"chronologische Unterteilung\" was given" do
      subject { element.get("chronologische Unterteilung") }

      it { is_expected.to be_an(Array) }
      it { is_expected.to eq(["2015"]) }
    end
  end
end
