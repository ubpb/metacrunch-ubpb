require "metacrunch/ubpb/record"

describe Metacrunch::UBPB::Record do
  let(:document) { Metacrunch::Mab2::Document.new }
  let(:record) { described_class.new(document) }

  describe "#get" do
    context "if \"allgemeine Materialbenennungen\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="334" ind1="-" ind2="1">
            <subfield code="a">Elektronische Ressource</subfield>
          </datafield>
        xml
      end

      subject { record.get("allgemeine Materialbenennungen").map(&:get) }

      it { is_expected.to eq(["Elektronische Ressource"]) }
    end

    context "if \"Angaben zum Inhalt\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="521" ind1="-" ind2="1">
            <subfield code="t">Gesang der drei Männer im feurigen Ofen (SWV 448)</subfield>
          </datafield>
          <datafield tag="521" ind1="-" ind2="2">
            <subfield code="t">Unser Herr Jesus Christus (SWV 495)</subfield>
          </datafield>
        xml
      end

      subject { record.get("Angaben zum Inhalt").map { |e| e.get("Titel") } }

      it { is_expected.to eq(["Gesang der drei Männer im feurigen Ofen (SWV 448)"]) }

      context "if \"include: Überordnungen\" was given" do
        subject { record.get("Angaben zum Inhalt", include: "Überordnungen").map { |e| e.get("Titel") } }

        it { is_expected.to eq(["Gesang der drei Männer im feurigen Ofen (SWV 448)", "Unser Herr Jesus Christus (SWV 495)"]) }
      end
    end

    context "if \"Arten des Inhalts\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="064" ind1="a" ind2="1">
            <subfield code="a">Zeitschrift</subfield>
            <subfield code="9">(DE-588)4067488-5</subfield>
          </datafield>
        xml
      end

      subject { record.get("Arten des Inhalts").map(&:get) }

      it { is_expected.to eq(["Zeitschrift"]) }
    end

    context "if \"bevorzugte Titel des Werkes\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="303" ind1="-" ind2="1">
            <subfield code="t">Werktitel</subfield>
          </datafield>
        xml
      end

      subject { record.get("bevorzugte Titel des Werkes").map(&:get) }

      it { is_expected.to eq(["Werktitel"]) }
    end

    context "if \"erweiterte Datenträgertypen\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="064" ind1="b" ind2="1">
            <subfield code="a">CD-ROM</subfield>
            <subfield code="9">(DE-588)4139307-7</subfield>
          </datafield>
        xml
      end

      subject { record.get("erweiterte Datenträgertypen").map(&:get) }

      it { is_expected.to eq(["CD-ROM"]) }
    end

    context "if \"ISBNs\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="540" ind1="a" ind2="1">
            <subfield code="a">9781610691192</subfield>
          </datafield>
        xml
      end

      subject { record.get("ISBNs").map(&:get) }

      it { is_expected.to eq(["9781610691192"]) }
    end

    context "if \"Körperschaften\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="-" ind2="1">
            <subfield code="k">Evangelische Auferstehungs-Kirchengemeinde</subfield>
          </datafield>
        xml
      end

      subject { record.get("Körperschaften").map(&:get) }

      it { is_expected.to eq(["Evangelische Auferstehungs-Kirchengemeinde"]) }
    end

    context "if \"Körperschaften (Phrasenindex)\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="PKO" ind1="-" ind2="1">
            <subfield code="k">Universität</subfield>
          </datafield>
        xml
      end

      subject { record.get("Körperschaften (Phrasenindex)").map(&:get) }

      it { is_expected.to eq(["Universität"]) }
    end

    context "if \"Manifestationstitel von weiteren verkörperten Werken\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="362" ind1="-" ind2="1">
            <subfield code="a">Test</subfield>
            <subfield code="v">hbz</subfield>
            <subfield code="Z">1</subfield>
          </datafield>
        xml
      end

      subject { record.get("Manifestationstitel von weiteren verkörperten Werken").map { |e| e.get("Titel") } }

      it { is_expected.to eq(["Test"]) }
    end

    context "if \"Personen\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="b" ind2="1">
            <subfield code="a">Wegner, Jochen</subfield>
          </datafield>
        xml
      end

      subject { record.get("Personen").map(&:get) }

      it { is_expected.to eq(["Wegner, Jochen"]) }
    end

    context "if \"Personen der Nebeneintragungen\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="800" ind1="-" ind2="1">
            <subfield code="p">Pius</subfield>
          </datafield>
        xml
      end

      subject { record.get("Personen der Nebeneintragungen").map(&:get) }

      it { is_expected.to eq(["Pius"]) }
    end

    context "if \"Personen (Phrasenindex)\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="PPE" ind1="-" ind2="1">
            <subfield code="p">Murmellius, Iohannes</subfield>
          </datafield>
        xml
      end

      subject { record.get("Personen (Phrasenindex)").map(&:get) }

      it { is_expected.to eq(["Murmellius, Iohannes"]) }
    end

    context "if \"unaufgegliederte Anmerkungen\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="501" ind1="-" ind2="1">
            <subfield code="a">Einige Ex ohne ISBN</subfield>
          </datafield>
        xml
      end

      subject { record.get("unaufgegliederte Anmerkungen").map(&:get) }

      it { is_expected.to eq(["Einige Ex ohne ISBN"]) }
    end
  end
end
