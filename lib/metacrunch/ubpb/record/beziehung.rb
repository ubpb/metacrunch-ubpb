require_relative "./element"

class Metacrunch::UBPB::Record::Beziehung < Metacrunch::UBPB::Record::Element
  SUBFIELDS = {
    p: { "Beziehungskennzeichnung" => :W },
    i: { "Beziehungskennzeichnung" => :W },
    n: { "Bemerkung" => :W },
    a: {
      "Titel" => :NW,
      "Titel der in Beziehung stehenden Ressource" => :NW,
      "Geistiger Schöpfer" => :NW
    },
    t: {
      "Titel der in Beziehung stehenden Ressource" => :NW
    },
    "9": {
      "Identifikationsnummer" => :NW,
      "Identifikationsnummer des Datensatzes der in Beziehung stehenden Ressource" => :NW
    },
    x: { "ISSN" => :NW },
    z: { "ISBN" => :NW }
  }

  def get(*args)
    if (result = super).is_a?(Array)
      result.map { |element| sanitize(element) }
    else
      sanitize(result)
    end
  end

  private

  def default_value(options = {})
    einleitung = [
      get("Beziehungskennzeichnung").compact.join(". "),
      get("Bemerkung").compact.join(". ")
    ].compact.join(" ").presence

    titel = get("Titel der in Beziehung stehenden Ressource").presence

    geistiger_schöpfer = get("Geistiger Schöpfer").presence
    geistiger_schöpfer = nil if titel && geistiger_schöpfer == titel

    isbn = get("ISBN").presence
    issn = get("ISSN").presence

    result = einleitung
    result = join(result, titel, separator: ": ")
    result = join(result, geistiger_schöpfer, separator: titel.present? ? " / " : " ")
    result = join(result, isbn, separator: titel.present? ? ".- ISBN " : " ISBN ")
    result = join(result, issn, separator: titel.present? ? ".- ISSN " : " ISSN ")

    result.presence
  end

  def sanitize(value)
    if value
      value
      .gsub("--->", ":")
      .gsub(/\.\s*\:/, ".:")
      .gsub(/:*\s*:/, ":")
      .strip
    end
  end

  def join(memo, string, separator: "")
    if string.blank?
      memo
    else
      if memo.present?
        memo + separator + string
      else
        string
      end
    end
  end
end
