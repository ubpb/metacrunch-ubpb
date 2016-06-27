describe Metacrunch::UBPB::Transformations::MabToPrimo::AddTitleDisplay do
  # should insert 'Bd.'
  define_field_test '001499879', title_display: 'Fakten und Fiktionen : Werklexikon der deutschsprachigen Schlüsselliteratur ; 1900 - 2010 / Bd. 1 : Andres bis Loest'

  # should not insert 'Bd.'
  define_field_test '001015068', title_display: 'Forum Geschichte kompakt - [Gymnasium] Nordrhein-Westfalen Bd. 2, Teilbd. 1, Von der Frühen Neuzeit bis zum Ersten Weltkrieg [Schülerbd.]'

  # '<<' and '>>' should be removed
  define_field_test '000954111', title_display: 'Kitakantō-igaku [Elektronische Ressource]'
  define_field_test '000992332', title_display: 'Der Hexenbürgermeister von Lemgo : ein Lesedrama in Versen'

  #
  # former title_display tests
  #
  define_field_test '000057960', title_display: 'Sämtliche Werke : historisch-kritische Ausgabe'
  define_field_test '000058000', title_display: 'Sämtliche Werke : historisch-kritische Ausgabe / Stücke 36 : Tannhäuser'
  define_field_test '000215104', title_display: 'Hiersemanns bibliographische Handbücher'
  define_field_test '000310864', title_display: 'Paderborner Universitätsreden'
  define_field_test '000392641', title_display: 'Hegel-Jahrbuch'
  define_field_test '000392645', title_display: 'Hegel-Jahrbuch 1966'
  define_field_test '000438377', title_display: 'Urkundenregesten zur Tätigkeit des deutschen Königs- und Hofgerichts bis 1451'
  define_field_test '000637121', title_display: 'Zeitschrift für Familienforschung : ZfF'
  define_field_test '000676616', title_display: 'Recht und Staat'
  define_field_test '000782994', title_display: 'Anleitungen eine Farbe zu lesen : Rot'
  define_field_test '001006945', title_display: 'Urkundenregesten zur Tätigkeit des deutschen Königs- und Hofgerichts bis 1451 / Bd. 14 : Die Zeit Wenzels 1397 - 1400'
  define_field_test '001015067', title_display: 'Forum Geschichte kompakt'
  define_field_test '001015070', title_display: 'Forum Geschichte kompakt - [Gymnasium] Nordrhein-Westfalen Bd. 2, Teilbd. 2, Vom Ende des Ersten Weltkriegs bis zur Gegenwart [Schülerbd.]'
  define_field_test '001108212', title_display: 'Johann Nestroy - Dokumente'
  define_field_test '001249043', title_display: 'Fractions, decimals, ratios, and percents : hard to teach and hard to learn? [Hauptbd.]'
  define_field_test '001499877', title_display: 'Fakten und Fiktionen : Werklexikon der deutschsprachigen Schlüsselliteratur ; 1900 - 2010'
  define_field_test '001499879', title_display: 'Fakten und Fiktionen : Werklexikon der deutschsprachigen Schlüsselliteratur ; 1900 - 2010 / Bd. 1 : Andres bis Loest'
  define_field_test '001499880', title_display: 'Fakten und Fiktionen : Werklexikon der deutschsprachigen Schlüsselliteratur ; 1900 - 2010 / Bd. 2 : Heinrich Mann bis Zwerenz'
  define_field_test '001510878', title_display: 'Tanzhaus' # short title would be '[Buch]', so take the superorder title
  define_field_test '001562173', title_display: 'Schwerpunktthema: Türkische Familien in Deutschland - Generationenbeziehungen und Generationenperspektiven'
  define_field_test '001568334', title_display: 'Software Engineering 2013 : Fachtagung des GI-Fachbereichs Softwaretechnik ; 26. Februar - 1. März 2013 in Aachen ; SE 2013 ; [Tagung Software Engineering]'
  define_field_test '001572048', title_display: 'Paderborner Rathaus-Vorlesungen'
  define_field_test '001572049', title_display: 'Alte und Neue Welt : zur wechselvollen Geschichte transatlanitischer Kulturkontakte'

  # use value in 310
  define_field_test '000452919', title_display: 'Statistik des Auslandes / Länderbericht / Korea, Demokratische Volksrepublik'
  define_field_test '000695045', title_display: 'Zeitschrift für Urheber- und Medienrecht / Sonderheft : ZUM'
  define_field_test '000479391', title_display: 'Quellen und Forschungen zur höchsten Gerichtsbarkeit im alten Reich / Sonderreihe'

  # UV167
  define_field_test '000605735', title_display: 'Zeitschrift für Urheber- und Medienrecht : ZUM'
  define_field_test '000695045', title_display: 'Zeitschrift für Urheber- und Medienrecht / Sonderheft : ZUM'
  define_field_test '001209722', title_display: 'Zeitschrift für Urheber- und Medienrecht : ZUM [Elektronische Ressource]'
  define_field_test '001209723', title_display: 'Zeitschrift für Urheber- und Medienrecht / Rechtsprechungsdienst : ZUM [Elektronische Ressource]'

  # UV183
  define_field_test '000897969', title_display: 'Praxis Geschichte : Zeitschrift für den Geschichtsunterricht in der Sek I/II'
  define_field_test '000998195', title_display: 'Praxis Geschichte [Elektronische Ressource]'

  #
  define_field_test '000558925', title_display: 'Der fremdsprachliche Unterricht / Englisch'
  define_field_test '001838193', title_display: 'Un franco, 14 pesetas : emprendían mucho más que un viaje ; iniciaban el camino hacia una nueva vida [DVD-Video]'
  define_field_test '001838225', title_display: 'Frozen river [DVD-Video]'
  define_field_test '001836826', title_display: 'Madonna : Frau - Mutter - Kultfigur [Ausstellungskatalog]'
  define_field_test '001840251', title_display: 'Filati special. Colors : coole Farbeffekte für jedes Outfit. [Deutsche Ausgabe] [Zeitschrift]'

  define_field_test '001838242', title_display: 'Die Fünfzigerjahre : deutsches Alltagsleben in Ost und West [Bildband]'
  define_field_test '001833425', title_display: 'Grammatik : eine Einführung [Einführung, Lehrbuch]'
  define_field_test '001840830', title_display: 'Kommunikationskabelnetze : mit Ausstellung : Vorträge der 22. ITG-Fachtagung vom 08.-09. Dezember 2015 in Köln [Konferenzschrift, CD-ROM]'

  #
  # synthetic tests
  #
  let(:transformation) { transformation_factory(described_class) }

  context "multiple hierachy levels" do
    context "for a RDA record" do
      subject do
        mab_xml = mab_xml_builder do
          datafield("089") do
            subfield("n", "Band 4")
            subfield("p", "<<Das>> 20. Jahrhundert")
            subfield("n", "Teilband 2")
          end

          datafield("331", ind2: "1") do
            subfield("a", "Von der Kritischen Theorie bis zur Globalisierung")
          end

          datafield("331", ind2: "2") do
            subfield("a", "Geschichte des politischen Denkens")
          end
        end

        transformation.call(mab_xml)["title_display"]
      end

      it { is_expected.to eq("Geschichte des politischen Denkens / Band 4. Das 20. Jahrhundert / Teilband 2 : Von der Kritischen Theorie bis zur Globalisierung") }
    end
  end
end
