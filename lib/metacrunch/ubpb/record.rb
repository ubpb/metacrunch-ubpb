require_relative "../ubpb"

class Metacrunch::UBPB::Record
  require_relative "./record/angabe_zum_inhalt"
  require_relative "./record/art_des_inhalts"
  require_relative "./record/bevorzugter_titel_des_werkes"
  require_relative "./record/beziehung"
  require_relative "./record/elektronische_adresse"
  require_relative "./record/erweiterter_datenträgertyp"
  require_relative "./record/generisches_element"
  require_relative "./record/isbn"
  require_relative "./record/issn"
  require_relative "./record/körperschaft"
  require_relative "./record/manifestationstitel_von_weiteren_verkörperten_werken"
  require_relative "./record/ort"
  require_relative "./record/person"
  require_relative "./record/veröffentlichungsspezifische_angaben_zu_fortlaufenden_sammelwerken"
  require_relative "./record/zählung"

  CONTROLFIELDS = [
    { tags: ["052"], accessor: "veröffentlichungsspezifische Angaben zu fortlaufenden Sammelwerken",     type: VeröffentlichungsspezifischeAngabenZuFortlaufendenSammelwerken }
  ]

  DATAFIELDS = [
    { tags: ["064"], ind1: ["a"],      accessor: "Arten des Inhalts",                                    type: ArtDesInhalts },
    { tags: ["064"], ind1: ["b"],      accessor: "erweiterte Datenträgertypen",                          type: ErweiterterDatenträgertyp },
    { tags: (100..196).step(4), ind2: ["1", "2"], accessor: "Personen",                                             type: Person },
    { tags: (200..296).step(4), ind2: ["1", "2"], accessor: "Körperschaften",                                       type: Körperschaft },
    { tags: ["303"], ind1: ["-"],      accessor: "bevorzugte Titel des Werkes",                          type: BevorzugterTitelDesWerkes },
    { tags: ["303"], ind1: ["t"],      accessor: "in Beziehung stehende Werke",                          type: BevorzugterTitelDesWerkes },
    { tags: ["334"],                   accessor: "allgemeine Materialbenennungen",                       type: GenerischesElement },
    { tags: ["359"],                   accessor: "Verantwortlichkeitsangaben",                           type: GenerischesElement },
    { tags: ["362"],                   accessor: "Manifestationstitel von weiteren verkörperten Werken", type: ManifestationstitelVonWeiterenVerkörpertenWerken },
    { tags: ["359"],                   accessor: "Verantwortlichkeitsangaben",                           type: GenerischesElement },
    { tags: ["501"],                   accessor: "unaufgegliederte Anmerkungen",                         type: GenerischesElement },
    { tags: ["521"],                   accessor: "Angaben zum Inhalt",                                   type: AngabeZumInhalt },
    { tags: ["526"],                   accessor: "Titel von rezensierten Werken",                        type: Beziehung },
    { tags: ["527", "775", "776"],     accessor: "andere Ausgaben",                                      type: Beziehung },
    { tags: ["528"],                   accessor: "Titel von Rezensionen",                                type: Beziehung },
    { tags: ["529", "770"],            accessor: "Beilagen",                                             type: Beziehung },
    { tags: ["530", "772"],            accessor: "übergeordnete Einheiten der Beilage",                  type: Beziehung },
    { tags: ["531", "780"],            accessor: "Vorgänger",                                            type: Beziehung },
    { tags: ["533", "785"],            accessor: "Nachfolger",                                           type: Beziehung },
    { tags: ["534", "787"],            accessor: "sonstige Beziehungen",                                 type: Beziehung },
    { tags: ["777"],                   accessor: "erschienen mit",                                       type: Beziehung },
    { tags: ["649"],                   accessor: "Angaben zum Original (Sekundärform)",                  type: Beziehung },
    { tags: ["537"],                   accessor: "redaktionelle Bemerkungen",                            type: GenerischesElement },
    { tags: ["540"],                   accessor: "ISBNs",                                                type: ISBN },
    { tags: ["590"],                   accessor: "Haupttitel der Quelle",                                type: GenerischesElement },
    { tags: ["591"],                   accessor: "Verantwortlichkeitsangabe der Quelle",                 type: GenerischesElement },
    { tags: ["592"],                   accessor: "Unterreihe der Quelle",                                type: GenerischesElement },
    { tags: ["593"],                   accessor: "Ausgabebezeichnung der Quelle in Vorlageform",         type: GenerischesElement },
    { tags: ["594"], ind1: ["-"],      accessor: "Verlagsorte der Quelle",                               type: Ort },
    { tags: ["594"], ind1: ["a"],      accessor: "Druckorte der Quelle",                                 type: Ort },
    { tags: ["594"], ind1: ["b"],      accessor: "Vetriebsorte der Quelle",                              type: Ort },
    { tags: ["594"], ind1: ["c"],      accessor: "Auslieferungsorte der Quelle",                         type: Ort },
    { tags: ["595"],                   accessor: "Erscheinungsjahr der Quelle",                          type: GenerischesElement },
    { tags: ["596"],                   accessor: "Zählungen der Quellen",                                type: Zählung },
    { tags: ["597"],                   accessor: "Reihe der Quelle",                                     type: GenerischesElement },
    { tags: ["598"],                   accessor: "Anmerkung zur Quelle",                                 type: GenerischesElement },
    { tags: ["599"], ind1: ["-"],      accessor: "Identifikationsnummern der selbständigen Schrift",     type: GenerischesElement },
    { tags: ["599"], ind1: ["a", "b"], accessor: "ISSNs der Quelle",                                     type: ISSN },
    { tags: ["599"], ind1: ["c", "d"], accessor: "ISBNs der Quelle",                                     type: ISBN },
    { tags: ["599"], ind1: ["e", "f"], accessor: "ISMNs der Quelle",                                     type: GenerischesElement },
    { tags: ["599"], ind1: ["g", "h"], accessor: "ISRNs der Quelle",                                     type: GenerischesElement },
    { tags: ["599"], ind1: ["s"],      accessor: "Identifkationsnummer der ZDB",                         type: GenerischesElement },
    { tags: ["655"], ind1: ["-", "e", " "], accessor: "elektronische Adressen",                               type: ElektronischeAdresse },
    { tags: (800..824).step(6),        accessor: "Personen der Nebeneintragungen",                       type: Person },
    { tags: ["PKO"],                   accessor: "Körperschaften (Phrasenindex)",                        type: Körperschaft },
    { tags: ["PPE"],                   accessor: "Personen (Phrasenindex)",                              type: Person },
  ]

  delegate :controlfield, :datafields, to: :@document

  def initialize(document)
    @document = document
    @properties = {}

    CONTROLFIELDS.each do |entry|
      entry[:tags]
      .to_a
      .map do |tag|
        entry[:type].new(document.controlfield(tag.to_s))
      end
      .each do |object|
        if accessor = entry[:accessor]
          @properties[accessor] = object
        end
      end
    end

    DATAFIELDS.each do |entry|
      entry[:tags]
      .to_a
      .map do |tag|
        document.datafields(tag.to_s, { ind1: entry[:ind1], ind2: entry[:ind2] }.compact)
      end
      .try do |datafield_sets|
        datafield_sets.map do |datafield_set|
          datafield_set.map do |datafield|
            entry[:type].new(datafield)
          end
        end
        .flatten(1)
      end
      .try do |objects|
        if accessor = entry[:accessor]
          @properties[accessor] = objects
        end
      end
    end
  end

  def get(accessor, options = {})
    if (collection = @properties[accessor]).is_a?(Array)
      collection.select do |element|
        element.selected?(options)
      end
    else element = @properties[accessor]
      element if element.selected?(options)
    end
  end
end
