require "metacrunch/ubpb/record/körperschaft"

describe Metacrunch::UBPB::Record::Körperschaft do
  describe "#get" do
    context "Körperschaft mit untergeordneten Körperschaften" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="-" ind2="1">
            <subfield code="k">Evangelische Auferstehungs-Kirchengemeinde</subfield>
            <subfield code="h">Völklingen</subfield>
            <subfield code="b">Evangelische Jugendtheater-AG</subfield>
            <subfield code="h">Wehrden-Geislautern</subfield>
            <subfield code="9">(DE-588)16014053-5</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Evangelische Auferstehungs-Kirchengemeinde (Völklingen). Evangelische Jugendtheater-AG (Wehrden-Geislautern)") }
    end

    context "Körperschaft mit unstrukturiertem Namen" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="-" ind2="1">
            <subfield code="a">Associated Ministers of Worcester-shire</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Associated Ministers of Worcester-shire") }
    end

    context "Körperschaft mit Beziehungskennzeichnung" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="b" ind2="1">
            <subfield code="k">Deutscher Anwaltverein</subfield>
            <subfield code="b">Arbeitsgemeinschaft IT-Recht</subfield>
            <subfield code="9">(DE-588)1067272690</subfield>
            <subfield code="4">isb</subfield>
            <subfield code="3">Herausgebendes Organ</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Deutscher Anwaltverein. Arbeitsgemeinschaft IT-Recht") }

      context "if include: \"Beziehungskennzeichnungen\" given" do
        subject { element.get(include: "Beziehungskennzeichnungen") }

        it { is_expected.to eq("Deutscher Anwaltverein. Arbeitsgemeinschaft IT-Recht [Herausgebendes Organ]") }
      end
    end

    context "Körperschaft mit mehreren Funktionsbezeichnungen" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="b" ind2="1">
            <subfield code="k">Centre de Recherches Mathématiques</subfield>
            <subfield code="9">(DE-588)1020069-1</subfield>
            <subfield code="4">isb</subfield>
            <subfield code="3">Herausgebendes Organ</subfield>
            <subfield code="4">orm</subfield>
            <subfield code="3">Veranstalter</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Centre de Recherches Mathématiques") }

      context "if include: \"Beziehungskennzeichnungen\" given" do
        subject { element.get(include: "Beziehungskennzeichnungen") }

        it { is_expected.to eq("Centre de Recherches Mathématiques [Herausgebendes Organ, Veranstalter]") }
      end
    end

    context "Konferenz mit Zählung, Datum, Ort und Zusatz" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="b" ind2="1">
            <subfield code="e">WM</subfield>
            <subfield code="n">5</subfield>
            <subfield code="d">2009</subfield>
            <subfield code="c">Solothurn</subfield>
            <subfield code="h">Institut für Wirtschaftsinformatik, Basel</subfield>
            <subfield code="9">(DE-588)16004886-2</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("WM (5 : 2009 : Solothurn, Institut für Wirtschaftsinformatik, Basel)") }
    end

    context "Körperschaft mit allgemeiner Unterteilung" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="-" ind2="1">
            <subfield code="k">Sydney</subfield>
            <subfield code="x">Art Gallery of New South Wales</subfield>
            <subfield code="x">John Kaldor Familiy Collection</subfield>
            <subfield code="9">(DE-588)7846930-2</subfield>
            <subfield code="H">Kaldor, John</subfield>
            <subfield code="H">Sammlung</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Sydney / Art Gallery of New South Wales / John Kaldor Familiy Collection") }
    end

    context "Konferenz mit mehreren Zählungen" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="b" ind2="1">
            <subfield code="e">Werkstoffwoche</subfield>
            <subfield code="n">2</subfield>
            <subfield code="d">1998</subfield>
            <subfield code="c">München</subfield>
            <subfield code="b">Symposium</subfield>
            <subfield code="n">8</subfield>
            <subfield code="9">(DE-588)2175030-0</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Werkstoffwoche (2 : 1998 : München). Symposium (8)") }
    end

    context "Gebietskörperschaft mit Zusatz" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="200" ind1="-" ind2="1">
            <subfield code="g">Steinheim</subfield>
            <subfield code="h">Kreis Höxter</subfield>
            <subfield code="9">(DE-588)4057182-8</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Steinheim (Kreis Höxter)") }
    end
  end
end
