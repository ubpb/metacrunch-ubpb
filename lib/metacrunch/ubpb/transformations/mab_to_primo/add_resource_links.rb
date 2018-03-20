require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddResourceLinks < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "resource_links", resource_links) : resource_links
    target ? Metacrunch::Hash.add(target, "fulltext_links", fulltext_links) : fulltext_links
  end

private

  def resource_links
    links = []

    source.datafields('655', ind1: 'e').each do |datafield|
      url        = datafield.subfields('u').value # URL
      label      = datafield.subfields('y').value || datafield.subfields('3').value # Label
      subfield_A = datafield.subfields('A').value # 2 = Gehört zum Werk, z.B. Inhaltsverzeichnis, Vorwort, etc.

      if url.present? && label.present? && (subfield_A == "2" || label.match(/inhalt/i))
        links << {
          label: label,
          url: url
        }
      end
    end

    links.uniq{|link| link[:url]}
  end

  def fulltext_links
    links = []

    source.datafields('655', ind1: 'e').each do |datafield|
      url        = datafield.subfields('u').value # URL
      label      = datafield.subfields('y').value || datafield.subfields('3').value # Label
      subfield_A = datafield.subfields('A').value # nil || != 2 => Ist ein Volltextlink

      if url.present? && subfield_A != "2" && !label&.match(/inhalt/i)
        links << url
      end
    end

    links.uniq
  end

end
