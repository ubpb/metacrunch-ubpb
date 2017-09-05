require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"
require_relative "./add_title_display"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddTitleSearch < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "title_search", title_search) : title_search
  end

  private

  def title_search
    search_titles = []
    search_titles << title_display

    (342..355).each do |f|
      search_titles << source.datafields("#{f}", ind2: '1').subfields('a').values
    end

    search_titles << source.datafields('370', ind2: '1').subfields('a').values

    search_titles << source.datafields('376', ind2: '1').subfields('a').values
    (451..491).step(10).each do |f|
      search_titles << source.datafields("#{f}", ind2: '1').subfields('a').values
    end
    search_titles << source.datafields('502', ind2: '1').subfields('a').values
    search_titles << source.datafields('504', ind2: '1').subfields('a').values
    search_titles << source.datafields('505', ind2: '1').subfields('a').values
    (526..534).each do |f|
      search_titles << source.datafields("#{f}", ind2: '1').subfields('a').values
    end
    search_titles << source.datafields('621', ind2: '1').subfields('a').values
    search_titles << source.datafields('627', ind2: '1').subfields('a').values
    search_titles << source.datafields('633', ind2: '1').subfields('a').values

    # frühere Titel (RDA)
    source.datafields('375', ind2: [:blank, '1']).each do |_datafield|
      _früherer_titel = _datafield.subfields('a').value
      search_titles << _früherer_titel
    end

    # übersetzter Titel (RDA)
    source.datafields('377').each do |datafield|
      search_titles << datafield.subfields('a').value
    end

    source.get("Angaben zum Inhalt").each do |element|
      search_titles << element.get("Titel")
    end

    source.get("bevorzugte Titel des Werkes").each do |element|
      search_titles << element.get("Titel")
    end

    source.get("in Beziehung stehende Werke").each do |element|
      search_titles << element.get("Titel")
    end

    source.get("Manifestationstitel von weiteren verkörperten Werken").each do |element|
      search_titles << element.get("Titel")
    end

    search_titles
    .flatten
    .compact
    .map do |search_title|
      # add entries without dashes in words, if words with dashes are present
      if search_title.match(/[A-ZÄÖÜ][a-zäöü]+\-[A-ZÄÖÜ][a-zäöü]+/)
        [search_title, search_title.split(' ').map { |string| string.gsub(/([A-ZÄÖÜ][a-zäöü]+)\-([A-ZÄÖÜ][a-zäöü]+)/, '\1\2').downcase.capitalize }.join(' ')]
      else
        search_title
      end
    end
    .flatten
    .map(&:presence)
    .compact
    .map do |_title_search|
      _title_search.gsub(/\[.+\]/, "").strip
    end
    .compact
    .uniq
  end

  private

  def title_display
    target.try(:[], "title_display") || self.class.parent::AddTitleDisplay.new(source: source).call
  end
end
