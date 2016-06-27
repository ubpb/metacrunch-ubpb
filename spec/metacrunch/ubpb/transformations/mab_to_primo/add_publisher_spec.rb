describe Metacrunch::UBPB::Transformations::MabToPrimo::AddPublisher do
  transformation = transformation_factory(described_class)

  # remove << .... >>
  define_field_test '000312406', publisher: 'Berlin : de Gruyter Saur', transformation: transformation # &lt;&lt;de&gt;&gt; Gruyter Saur
  define_field_test '001206544', publisher: 'Leipzig : Leipziger Univ.-Verl.', transformation: transformation
  define_field_test '001231060', publisher: ['Washington, DC : The World Bank', 'Paris : OECD Publishing'], transformation: transformation

  define_field_test '001839081', publisher: 'Paderborn'
  define_field_test '001839082', publisher: 'Paderborn'
  define_field_test '001843481', publisher: 'Opladen ; Berlin ; Toronto : Verlag Barbara Budrich'
  define_field_test '001840202', publisher: [
    "Sprockhövel : Edition Dr. Eike Pies",
    "Sprockhövel : Familienstiftung Pies-Archiv [laufende/letze Angabe]"
  ]

  # RAK
  #
  # f410 [NW]
  #    a Ort des 1. Verlagers [WDH]
  #
  # f412 [NW]
  #    a Name des 1. Verlegers [WDH]
  #
  # f415 [NW]
  #    a Ort des 2. Verlegers
  #
  # f417 [NW]
  #    a Name des 2. Verlegers
  #
  # RDA
  #
  # f419 [WDH]
  #    a Ort(e) (ggf. mehrere durch ; getrennt)
  #    b Verlagsname
  #    c Datumsangabe
  context "one publisher, one place" do
    context "for a RAK record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("410", ind2: "1") { subfield("a", "First publisher place") }
          datafield("412", ind2: "1") { subfield("a", "First publisher") }
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq("First publisher place : First publisher") }
    end

    context "for a RDA record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("419") do
            subfield("a", "First publisher place")
            subfield("b", "First publisher")
          end
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq("First publisher place : First publisher") }
    end
  end

  context "one publisher, multiple places" do
    context "for a RAK record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("410", ind2: "1") { subfield("a", "First publisher place") }
          datafield("410", ind2: "1") { subfield("a", "Another place") }
          datafield("412", ind2: "1") { subfield("a", "First publisher") }

          datafield("415", ind2: "1") { subfield("a", "Second publisher place") }
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq("First publisher place : First publisher") }
    end

    context "for a RDA record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("419") do
            subfield("a", "First publisher place")
            subfield("a", "First publisher second place")
            subfield("b", "First publisher")
          end

          datafield("419") do
            subfield("a", "Another place")
          end
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq(["First publisher place : First publisher", "Another place"]) }
    end
  end

  context "multiple publishers, multiple places" do
    context "for a RAK record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("410", ind2: "1") { subfield("a", "First publisher place") }
          datafield("412", ind2: "1") { subfield("a", "First publisher") }

          datafield("415", ind2: "1") { subfield("a", "Second publisher place") }
          datafield("417", ind2: "1") { subfield("a", "Second publisher") }
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq(["First publisher place : First publisher", "Second publisher place : Second publisher"]) }
    end

    context "for a RDA record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("419") do
            subfield("a", "First publisher place")
            subfield("b", "First publisher")
          end

          datafield("419") do
            subfield("a", "Second publisher place")
            subfield("b", "Second publisher")
          end
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq(["First publisher place : First publisher", "Second publisher place : Second publisher"]) }
    end
  end

  context "multiple publishers, not all having an associated place" do
    context "for a RAK record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("410", ind2: "1") { subfield("a", "First publisher place") }
          datafield("412", ind2: "1") { subfield("a", "First publisher") }

          datafield("417", ind2: "1") { subfield("a", "Second publisher") }
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq(["First publisher place : First publisher", "Second publisher"]) }
    end

    context "for a RDA record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("419") do
            subfield("a", "First publisher place")
            subfield("b", "First publisher")
          end

          datafield("419") do
            subfield("b", "Second publisher")
          end
        end

        transformation.call(mab_xml)["publisher"]
      end

      it { is_expected.to eq(["First publisher place : First publisher", "Second publisher"]) }
    end
  end

  context "multiple publishers, multiple places within repeated subfields (RAK)" do
    subject do
      mab_xml = mab_xml_builder do
        datafield("410", ind2: "1") { subfield("a", "First publisher place") }
        datafield("410", ind2: "1") { subfield("a", "Second publisher place") }

        datafield("412", ind2: "1") { subfield("a", "First publisher") }
        datafield("412", ind2: "1") { subfield("a", "Second publisher") }
      end

      transformation.call(mab_xml)["publisher"]
    end

    it { is_expected.to eq(["First publisher place : First publisher", "Second publisher place : Second publisher"]) }
  end

  context "multiple places for a single publisher (RDA)" do
    subject do
      mab_xml = mab_xml_builder do
        datafield("419") do
          subfield("a", "First publisher first place ; First publisher second place")
          subfield("b", "First publisher")
        end
      end

      transformation.call(mab_xml)["publisher"]
    end

    it { is_expected.to eq("First publisher first place ; First publisher second place : First publisher") }
  end
end
