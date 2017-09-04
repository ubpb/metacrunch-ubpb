require "metacrunch/ubpb/record/bevorzugter_titel_des_werkes"

describe Metacrunch::UBPB::Record::BevorzugterTitelDesWerkes do
  describe "#get" do
    let(:document) do
      Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
        <datafield tag="303" ind1="-" ind2="1">
          <subfield code="p">Rubinštejn, Anton G.</subfield>
          <subfield code="d">1829-1894</subfield>
          <subfield code="t">Lieder</subfield>
          <subfield code="n">op. 32</subfield>
          <subfield code="u">Der Asra</subfield>
          <subfield code="9">(DE-588)106683511X</subfield>
        </datafield>
      xml
    end
    let(:datafields) { document.datafields("303", ind2: "1") }
    let(:titel) { described_class.new(datafields.first) }

    subject { titel.get }

    it { is_expected.to eq("Der Asra") }

    context "if include: \"Überordnungen\" was given" do
      subject { titel.get(include: "Überordnungen") }

      it { is_expected.to eq("Lieder, op. 32. Der Asra") }
    end

    context "if omit: \"sortierirrelevante Worte\" was not given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="303" ind1="-" ind2="1">
            <subfield code="p">Zinczenko, David</subfield>
            <subfield code="t">&lt;&lt;The&gt;&gt; abs diet: the six-week plan to flatten your stomach</subfield>
          </datafield>
        xml
      end

      subject { titel.get }

      it { is_expected.to eq("The abs diet: the six-week plan to flatten your stomach") }
    end

    context "if omit: \"sortierirrelevante Worte\" was given" do
      let(:document) do
        Metacrunch::Mab2::Document.from_mab_xml xml_factory <<-xml.strip_heredoc
          <datafield tag="303" ind1="-" ind2="1">
            <subfield code="p">Zinczenko, David</subfield>
            <subfield code="t">&lt;&lt;The&gt;&gt; abs diet: the six-week plan to flatten your stomach</subfield>
          </datafield>
        xml
      end

      subject { titel.get(omit: "sortierirrelevante Worte") }

      it { is_expected.to eq("abs diet: the six-week plan to flatten your stomach") }
    end
  end
end
