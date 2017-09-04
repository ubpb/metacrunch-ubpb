require "metacrunch/ubpb/record/beziehung"

describe Metacrunch::UBPB::Record::Beziehung do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="527" ind1="z" ind2="1">
          <subfield code="p">Übersetzung von</subfield>
          <subfield code="a">The photographic card deck of the elements / Theodore Gray</subfield>
        </datafield>
      xml
    end
    let(:element) { described_class.new(document.datafields.first) }

    subject { element.get }

    it { is_expected.to eq("Übersetzung von: The photographic card deck of the elements / Theodore Gray") }

    # former spec
    context "if datafield is 526" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="526" ind1="z" ind2="1">
            <subfield code="p">Rezension von</subfield>
            <subfield code="a">Gegenbaur, Carl: Lehrbuch der Anatomie des Menschen</subfield>
            <subfield code="9">HT008761118</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Rezension von: Gegenbaur, Carl: Lehrbuch der Anatomie des Menschen") }
    end

    # former spec
    context "if datafield is 528" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="528" ind1="z" ind2="1">
            <subfield code="p">Rezension siehe</subfield>
            <subfield code="a">Becker-Willhardt, Hannelore: Thomas Mann und die Italiener</subfield>
            <subfield code="9">HT016029253</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Rezension siehe: Becker-Willhardt, Hannelore: Thomas Mann und die Italiener") }
    end

    # former spec
    context "if datafield is 529" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="529" ind1="z" ind2="1">
            <subfield code="p">Supplement</subfield>
            <subfield code="n">2004-2010, Nr. 18</subfield>
            <subfield code="a">Dresdener Nachrichten</subfield>
          </datafield>
        xml
      end
      let(:element) { described_class.new(document.datafields.first) }

      subject { element.get }

      it { is_expected.to eq("Supplement 2004-2010, Nr. 18: Dresdener Nachrichten") }

      context "if \"sortierirrelevante Worte\" are present" do
        let(:document) do
          Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
            <datafield tag="529" ind1="z" ind2="2">
              <subfield code="p">1997 - 2005 Förderbeil.</subfield>
              <subfield code="a">&lt;&lt;Der&gt;&gt; Zettel</subfield>
              <subfield code="9">HT013041640</subfield>
            </datafield>
          xml
        end

        it { is_expected.to eq("1997 - 2005 Förderbeil.: Der Zettel") }
      end

      context "if \"Titel\" was given" do
        let(:document) do
          Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
            <datafield tag="529" ind1="z" ind2="2">
              <subfield code="p">1997 - 2005 Förderbeil.</subfield>
              <subfield code="a">&lt;&lt;Der&gt;&gt; Zettel</subfield>
              <subfield code="9">HT013041640</subfield>
            </datafield>
          xml
        end

        subject { element.get("Titel") }

        it { is_expected.to eq("Der Zettel") }

        context "if omit: \"sortierirrelevante Worte\" was given" do
          subject { element.get("Titel", omit: "sortierirrelevante Worte") }

          it { is_expected.to eq("Zettel")}
        end
      end
    end

    context "if datafield contains \"Bemerkung\"" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="527" ind1="z" ind2="1">
            <subfield code="p">Parallele Sprachausgabe</subfield>
            <subfield code="n">englisch</subfield>
            <subfield code="a">Annual report / Landesbank Berlin Holding</subfield>
          </datafield>
        xml
      end

      it { is_expected.to eq("Parallele Sprachausgabe englisch: Annual report / Landesbank Berlin Holding") }
    end

    context "if \"sortierirrelevante Worte\" are present" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="527" ind1="-" ind2="1">
            <subfield code="p">Druckausg.</subfield>
            <subfield code="a">&lt;&lt;The&gt;&gt; trend management toolkit</subfield>
          </datafield>
        xml
      end

      it { is_expected.to eq("Druckausg.: The trend management toolkit") }
    end

    context "if \"Titel der in Beziehung stehenden Ressource\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="527" ind1="-" ind2="1">
            <subfield code="p">Druckausg.</subfield>
            <subfield code="a">&lt;&lt;The&gt;&gt; trend management toolkit</subfield>
          </datafield>
        xml
      end

      subject { element.get("Titel der in Beziehung stehenden Ressource") }

      it { is_expected.to eq("The trend management toolkit") }

      context "if omit: \"sortierirrelevante Worte\" was given" do
        subject { element.get("Titel der in Beziehung stehenden Ressource", omit: "sortierirrelevante Worte") }

        it { is_expected.to eq("trend management toolkit")}
      end
    end
  end
end
