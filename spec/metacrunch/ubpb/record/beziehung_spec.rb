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

    context "if datafield is 770" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag='770' ind1=' ' ind2=' '>
            <subfield code='i'>
              Sonderpubl.
            </subfield>
            <subfield code='a'>
              INTERKAMA
            </subfield>
            <subfield code='t'>
              &lt;&lt;Der&gt;&gt; Interkama-Messeführer
            </subfield>
            <subfield code='d'>
              München : Oldenbourg, 1989-
            </subfield>
            <subfield code='9'>
              HT012608177
            </subfield>
          </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Sonderpubl.: Der Interkama-Messeführer / INTERKAMA") }
    end

    context "if datafield is 772" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag='772' ind1=' ' ind2=' '>
            <subfield code='i'>
              Beil. zu:
            </subfield>
            <subfield code='t'>
              Automatisierungstechnik
            </subfield>
            <subfield code='d'>
              Berlin ; Boston, Mass. : de @Gruyter, Oldenbourg, 1985-
            </subfield>
            <subfield code='x'>
              0178-2312
            </subfield>
            <subfield code='9'>
              HT002184071
            </subfield>
          </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Beil. zu: Automatisierungstechnik.- ISSN 0178-2312") }
    end

    context "if datafield is 775" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag='775' ind1=' ' ind2=' '>
            <subfield code='i'>
              Parallele Sprachausgabe
            </subfield>
            <subfield code='n'>
              französisch
            </subfield>
            <subfield code='a'>
              Ionesco, Dina
            </subfield>
            <subfield code='t'>
              Atlas des migrations environnementales
            </subfield>
            <subfield code='z'>
              978-2-7246-1655-2
            </subfield>
          </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Parallele Sprachausgabe französisch: Atlas des migrations environnementales / Ionesco, Dina.- ISBN 978-2-7246-1655-2") }
    end

    context "if datafield is 776" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag='776' ind1=' ' ind2=' '>
            <subfield code='i'>
              Online-Ausg.
            </subfield>
            <subfield code='t'>
              Automatisierungstechnik
            </subfield>
            <subfield code='d'>
              Berlin : De Gruyter, 1985-
            </subfield>
            <subfield code='h'>
              Online-Ressource
            </subfield>
            <subfield code='x'>
              2196-677X
            </subfield>
            <subfield code='9'>
              HT013018339
            </subfield>
          </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Online-Ausg.: Automatisierungstechnik.- ISSN 2196-677X") }
    end

    context "if datafield is 777" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag='777' ind1=' ' ind2=' '>
            <subfield code='i'>
              Auf Disk mit
            </subfield>
            <subfield code='a'>
              Milestone, Lewis
            </subfield>
            <subfield code='t'>
              &lt;&lt;The&gt;&gt; front page
            </subfield>
            <subfield code='d'>
              Rockport, MA, Synergy Entertainment, 2007
            </subfield>
            <subfield code='9'>
              KK000027236
            </subfield>
          </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Auf Disk mit: The front page / Milestone, Lewis") }
    end

    context "if datafield is 780" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag='780' ind1=' ' ind2=' '>
            <subfield code='i'>
              Ab 1991 teils darin aufgeg.
            </subfield>
            <subfield code='t'>
              Messen, Steuern, Regeln
            </subfield>
            <subfield code='d'>
              München : Oldenbourg, 1963-1991
            </subfield>
            <subfield code='x'>
              0026-0347
            </subfield>
            <subfield code='A'>
              0
            </subfield>
            <subfield code='9'>
              HT002717481
            </subfield>
          </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Ab 1991 teils darin aufgeg.: Messen, Steuern, Regeln.- ISSN 0026-0347") }
    end

    context "if datafield is 785" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag='785' ind1=' ' ind2=' '>
            <subfield code='i'>
              Forts.:
            </subfield>
            <subfield code='t'>
              Atp-Edition
            </subfield>
            <subfield code='d'>
              München : DIV Dt. Industrieverl., 2009-
            </subfield>
            <subfield code='x'>
              2190-4111
            </subfield>
            <subfield code='A'>
              0
            </subfield>
            <subfield code='9'>
              HT016138735
            </subfield>
          </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Forts.: Atp-Edition.- ISSN 2190-4111") }
    end

    context "if datafield is 787" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
         <datafield tag='787' ind1=' ' ind2=' '>
           <subfield code='i'>
             Ergänzung
           </subfield>
           <subfield code='a'>
             Jürgen Weber, 1953-
           </subfield>
           <subfield code='t'>
             Einführung in das Controlling - Übungen und Fallstudien mit Lösungen
           </subfield>
           <subfield code='9'>
             HT018991407
           </subfield>
         </datafield>
        xml
      end

      subject { element.get }

      it { is_expected.to eq("Ergänzung: Einführung in das Controlling - Übungen und Fallstudien mit Lösungen / Jürgen Weber, 1953-") }
    end
  end
end
