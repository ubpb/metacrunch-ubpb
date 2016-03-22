require_relative "../element"

class Metacrunch::UBPB::Record::Element::AndereAusgabe < Metacrunch::UBPB::Record::Element
  SUBFIELDS = {
    p: { "Beziehungskennzeichnung" => :W },
    n: { "Bemerkung" => :W },
    a: { "Titel der in Beziehung stehenden Ressource" => :NW },
    "9": {
      "Identifikationsnummer" => :NW,
      "Identifikationsnummer des Datensatzes der in Beziehung stehenden Ressource" => :NW
    },
    Z: { "Zuordnung zum originalschriftlichen Feld" => :NW }
  }

  def get(*args)
    if (result = super).is_a?(Array)
      result.map { |element| element.gsub("--->", "").strip }
    else
      result.try(:gsub, "--->", "")
    end
  end

  private

  def default_value(options = {})
    [
      [
        get("Beziehungskennzeichnung").try(:first), # there are no real examples with more than one of it
        get("Bemerkung").try(:first)
      ]
      .compact
      .join(" ")
      .presence,
      get("Titel der in Beziehung stehenden Ressource")
    ]
    .compact
    .join(": ")
    .presence
  end
end
