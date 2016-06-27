describe Metacrunch::UBPB::Transformations::MabToPrimo::AddCreatorContributorDisplay do
  transformation = transformation_factory(described_class)

  context "a creator with multiple relationship designators" do
    subject do
      mab_xml = mab_xml_builder do
        datafield("100", ind1: "b", ind2: "1") do
          subfield("p", "Jahn, Andrea")
          subfield("d", "1964-")
          subfield("4", "edt")
          subfield("4", "wst")
        end
      end

      transformation.call(mab_xml)["creator_contributor_display"]
    end

    it { is_expected.to eq("Jahn, Andrea [Herausgeber, Verfasser von ergänzendem Text]") }
  end

  define_field_test '001792011', creator_contributor_display: [
    "Auer-Reinsdorff, Astrid [Verfasser, Herausgeber]",
    "Conrad, Isabell [Verfasser, Herausgeber]",
    "Deutscher Anwaltverein. Arbeitsgemeinschaft IT-Recht [Herausgebendes Organ]"
  ]

  define_field_test '001830953', creator_contributor_display: "Pott, Klaus Friedrich [Herausgeber]"

  define_field_test '000102057', creator_contributor_display: [
    "Projektträger DV im Bildungswesen",
    "Werkstattgespräch Analyse und Bewertung Wesentlicher Autoren- und Dialogsprachen für den Bereich des Bildungswesens (1973 : Paderborn)"
  ]

  define_field_test '001708346', creator_contributor_display: [
    "Bethmann-Hollweg, Moritz August von",
    "Böcking, Eduard",
    "[u.a.]"
  ]

  define_field_test '001214891', creator_contributor_display: nil
  define_field_test '001849479', creator_contributor_display: [
    "Balke, Friedrich [Mitwirkender]",
    "Balmes, Hans Jürgen [Herausgeber]",
    "Bong, Jörg [Herausgeber]",
    "Rösler, Alexander [Herausgeber]",
    "Vogel, Oliver [Herausgeber]",
    "Röggla, Kathrin [Herausgeber]"
  ]
end
