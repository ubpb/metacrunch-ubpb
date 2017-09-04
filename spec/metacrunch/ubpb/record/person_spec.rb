require "metacrunch/ubpb/record/person"

describe Metacrunch::UBPB::Record::Person do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="100" ind1="b" ind2="1">
          <subfield code="a">Wegner, Jochen</subfield>
          <subfield code="p">Wegner, Jochen</subfield>
          <subfield code="n">I.</subfield>
          <subfield code="d">1969-</subfield>
          <subfield code="9">(DE-588)1077760159</subfield>
          <subfield code="4">edt</subfield>
          <subfield code="3">Herausgeber</subfield>
          <subfield code="b">[Hrsg.]</subfield>
        </datafield>
      xml
    end
    let(:datafields) { document.datafields("100") }
    let(:person) { described_class.new(datafields.first) }

    context "if \"Name (unstrukturiert)\" was requested" do
      subject { person.get("Name (unstrukturiert)") }

      it { is_expected.to eq("Wegner, Jochen") }
    end

    context "if \"Name (strukturiert)\" was requested" do
      subject { person.get("Name (strukturiert)") }

      it { is_expected.to eq("Wegner, Jochen") }
    end

    context "if \"Zählung\" was requested" do
      subject { person.get("Zählung") }

      it { is_expected.to eq("I.") }
    end

    context "if \"Lebensdaten\" was requested" do
      subject { person.get("Lebensdaten") }

      it { is_expected.to eq("1969-") }
    end

    context "if \"GND Identifikationsnummer\" was requested" do
      subject { person.get("GND Identifikationsnummer") }

      it { is_expected.to eq("(DE-588)1077760159") }
    end

    context "if \"Beziehungscode\" was requested" do
      subject { person.get("Beziehungscode") }

      it { is_expected.to eq(["edt"]) }
    end

    context "if \"Funktionsbezeichnung in eckigen Klammern\" was requested" do
      subject { person.get("Funktionsbezeichnung in eckigen Klammern") }

      it { is_expected.to eq("[Hrsg.]") }
    end
  end

  describe "#get" do
    context "Person mit unstrukturiertem Namen" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="-" ind2="1">
            <subfield code="a">Stinson, Stephenie</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Stinson, Stephenie") }
    end

    context "Person mit strukturiertem Namen" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="b" ind2="1">
            <subfield code="p">Alama, Stanley</subfield>
            <subfield code="9">(DE-588)140086846</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Alama, Stanley") }
    end

    context "Person mit Funktionsbezeichnung" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="b" ind2="1">
            <subfield code="p">Alama, Stanley</subfield>
            <subfield code="9">(DE-588)140086846</subfield>
            <subfield code="b">[Hrsg.]</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Alama, Stanley") }

      context "wenn die Funktionsbezeichnung mit ausgegeben werden soll" do
        subject { element.get(include: "Funktionsbezeichnung") }

        it { is_expected.to eq("Alama, Stanley [Hrsg.]") }
      end

      context "wenn die Funktionsbezeichnung ausgeschrieben mit ausgegeben werden soll" do
        subject { element.get(include: "ausgeschriebene Funktionsbezeichnung") }

        it { is_expected.to eq("Alama, Stanley [Herausgeber]") }
      end
    end

    context "Person mit Beziehungskennzeichnungen" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="b" ind2="1">
            <subfield code="p">Wegner, Jochen</subfield>
            <subfield code="d">1969-</subfield>
            <subfield code="9">(DE-588)1077760159</subfield>
            <subfield code="4">edt</subfield>
            <subfield code="3">Herausgeber</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Wegner, Jochen") }

      context "wenn die Beziehungskennzeichnungen mit ausgegeben werden sollen" do
        subject { element.get(include: "Beziehungskennzeichnungen") }

        it { is_expected.to eq("Wegner, Jochen [Herausgeber]") }
      end
    end

    context "mehrere Personen mit Beziehungskennzeichnungen und Funktionsbezeichnung" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="b" ind2="1">
            <subfield code="p">Wegner, Jochen</subfield>
            <subfield code="d">1969-</subfield>
            <subfield code="9">(DE-588)1077760159</subfield>
            <subfield code="4">edt</subfield>
            <subfield code="3">Herausgeber</subfield>
          </datafield>
          <datafield tag="104" ind1="b" ind2="1">
            <subfield code="p">Alama, Stanley</subfield>
            <subfield code="9">(DE-588)140086846</subfield>
            <subfield code="b">[Hrsg.]</subfield>
          </datafield>
        xml
      end
      let(:elements) do
        document.datafields.map do |datafield|
          described_class.new(datafield)
        end
      end

      subject { elements.map(&:get) }

      it { is_expected.to eq(["Wegner, Jochen", "Alama, Stanley"]) }

      context "wenn die Beziehungskennzeichngen/Funktionsbezeichnung mit ausgegeben werden soll" do
        subject { elements.map { |element| element.get(include: ["Beziehungskennzeichnungen", "ausgeschriebene Funktionsbezeichnung"]) } }

        it { is_expected.to eq(["Wegner, Jochen [Herausgeber]", "Alama, Stanley [Herausgeber]"]) }
      end
    end

    context "Person mit Zählung, Beinamen und Funktionsbezeichnung" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="b" ind2="1">
            <subfield code="p">Alexius</subfield>
            <subfield code="n">I.</subfield>
            <subfield code="c">Imperium Byzantinum, Imperator</subfield>
            <subfield code="d">1041-1118</subfield>
            <subfield code="9">(DE-588)173144152</subfield>
            <subfield code="b">[Angebl. Verf.]</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Alexius I., Imperium Byzantinum, Imperator") }

      context "wenn die Beziehungskennzeichngen/ausgeschriebene Funktionsbezeichnung mit ausgegeben werden soll" do
        subject { element.get(include: ["Beziehungskennzeichnungen", "ausgeschriebene Funktionsbezeichnung"]) }

        it { is_expected.to eq("Alexius I., Imperium Byzantinum, Imperator [Angeblicher Verfasser]") }
      end
    end

    context "Person mit nicht sortierrelevanten Worten" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="100" ind1="b" ind2="1">
            <subfield code="p">Rohr, Alheidis &lt;&lt;von&gt;&gt;</subfield>
            <subfield code="d">1940-</subfield>
            <subfield code="9">(DE-588)142876216</subfield>
            <subfield code="b">[Bearb.]</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Rohr, Alheidis von") }

      context "wenn die sortierirrelevanten Worte entfernt werden sollen" do
        subject { element.get(omit: "sortierirrelevante Worte") }

        it { is_expected.to eq("Rohr, Alheidis") }
      end
    end
  end
end
