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

    source.get("Titel von rezensierten Werken").each do |element|
      relations << relation_factory(element.get, element.get("Identifikationsnummer"))
    end

    source.get("andere Ausgaben").each do |element|
      relations << relation_factory(element.get, element.get("Identifikationsnummer"))
    end

    source.get("Titel von Rezensionen").each do |element|
      relations << relation_factory(element.get, element.get("Identifikationsnummer"))
    end

    source.get("Beilagen").each do |element|
      relations << relation_factory(element.get, element.get("Identifikationsnummer"))
    end

    (530..534).each do |mab_field_number|
      source.datafields("#{mab_field_number}", ind2: '1').each do |datafield|
        ht_number = datafield.subfields('9').value
        label = [
          datafield.subfields('p').value,
          datafield.subfields('a').value.try(:gsub, /<<|>>/, '')
        ].compact.join(' ')

        relations << {ht_number: ht_number, label: label} if label
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
