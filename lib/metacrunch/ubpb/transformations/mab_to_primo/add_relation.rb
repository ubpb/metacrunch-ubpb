require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddRelation < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "relation", relation) : relation
  end

  private

  def relation
    relations = []

    # Identifikationsnummer der Primärform
    source.datafields('021').each do |_datafield|
      if identifikationsnummer = _datafield.subfields("a").value
        is_regionale_identifikationsnummer = _datafield.ind1 == "b"
        is_unbekannte_identifikationsnummer = _datafield.ind1 == "-"

        if is_regionale_identifikationsnummer || is_unbekannte_identifikationsnummer
          relations << {
            ht_number: identifikationsnummer,
            label: 'Primärform'
          }
        end
      end
    end

    # Identifikationsnummer der Sekundärform
    source.datafields('022').each do |_datafield|
      if identifikationsnummer = _datafield.subfields("a").value
        is_regionale_identifikationsnummer = _datafield.ind1 == "b"
        is_unbekannte_identifikationsnummer = _datafield.ind1 == "-"

        if is_regionale_identifikationsnummer || is_unbekannte_identifikationsnummer
          relations << {
            ht_number: identifikationsnummer,
            label: 'Sekundärform'
          }
        end
      end
    end

    [
      "Titel von rezensierten Werken",
      "andere Ausgaben",
      "Titel von Rezensionen",
      "Beilagen",
      "übergeordnete Einheiten der Beilage",
      "Vorgänger",
      "Nachfolger",
      "erschienen mit",
      "sonstige Beziehungen"
    ]
    .each do |property|
      source.get(property).each do |element|
        relations << relation_factory(element.get, element.get("Identifikationsnummer"))
      end
    end

    relations.flatten.select { |relation| relation[:label].present? }.map(&:to_json)
  end

  def relation_factory(label, id)
    {
      ht_number: id,
      label: label
    }
    .compact
  end
end
