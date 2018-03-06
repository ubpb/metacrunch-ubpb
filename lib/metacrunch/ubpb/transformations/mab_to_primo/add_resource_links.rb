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
      subfield_u = datafield.subfields('u').value # URL
      subfield_3 = datafield.subfields('3').value # Label
      subfield_A = datafield.subfields('A').value # 2 = Gehört zum Werk, z.B. Inhaltsverzeichnis, Vorwort, etc.

      if subfield_u.present? && subfield_3.present? && subfield_A == "2"
        links << {
          label: subfield_3,
          url: subfield_u
        }
      end
    end

    links.uniq{|link| link[:url]}
  end

  def fulltext_links
    links = []

    source.datafields('655', ind1: 'e').each do |datafield|
      subfield_u = datafield.subfields('u').value # URL
      #subfield_3 = datafield.subfields('3').value # Label
      subfield_A = datafield.subfields('A').value # nil || != 2 => Ist ein Volltextlink

      if subfield_u.present? && subfield_A != "2"
        links << subfield_u
        #links << {
        #  label: subfield_3,
        #  url: subfield_u
        #}
      end
    end

    links.uniq{|link| link[:url]}
  end

end
