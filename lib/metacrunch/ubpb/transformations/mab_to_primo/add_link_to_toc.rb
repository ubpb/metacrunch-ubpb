require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

#
# DEPRECATED: USE AddResourceLinks
#
class Metacrunch::UBPB::Transformations::MabToPrimo::AddLinkToToc < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "link_to_toc", link_to_toc) : link_to_toc
  end

  private

  def link_to_toc
    toc_links = []

    source.datafields('655').each do |datafield|
      url        = datafield.subfields('u').value
      subfield_3 = datafield.subfields('3') # HBZ Inhaltsverzeichnisse
      subfield_z = datafield.subfields('z') # BVB Inhaltsverzeichnisse
      subfield_t = datafield.subfields('t') # Type: VIEW => Adam Inhaltsverzeichnis

      if (url.present? && subfield_3.present? && subfield_3.value =~ /^inhaltsv/i) ||
         (url.present? && subfield_z.present? && subfield_z.value =~ /^inhaltsv/i) ||
         (url.present? && subfield_t.present? && subfield_t.value =~ /^view/i)
        toc_links << url
      end
    end

    toc_links.compact.uniq.presence
  end

end
