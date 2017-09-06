require_relative "./generisches_element"

class Metacrunch::UBPB::Record::Zählung < Metacrunch::UBPB::Record::GenerischesElement

  SUBFIELDS = {
    a: { "Zusammenfassung" => :NW }, # Non-RDA
    b: { "Band" => :NW },            # RDA
    h: { "Heft" => :NW },            # RDA
    j: { "Jahr" => :NW },            # RDA
    s: { "Seiten" => :NW }           # RDA
  }

  def get(property = nil, options = {})
    zusammenfassung = @properties["Zusammenfassung"]

    if zusammenfassung.present?
      zusammenfassung
    else
      # Beispiel: Heft 19 (1964), Seite 39-45 : Illustrationen
      result = join("", @properties["Band"], prepend_always: "Band ")
      result = join(result, @properties["Heft"], separator: ", ", prepend_always: "Heft ")
      result = join(result, @properties["Jahr"], separator: " ", wrap: "(@)")
      result = join(result, @properties["Seiten"], separator: ", ", prepend_always: "Seite ")
      result
    end
  end

private

  def join(memo, string, separator: "", wrap: "", prepend_always: "")
    if string.blank?
      memo
    else
      string = prepend_always + string

      if memo.present?
        string = wrap.gsub("@", string) if wrap.present?
        memo + separator + string
      else
        string
      end
    end
  end

end
