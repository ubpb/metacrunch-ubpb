require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddSubject < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "subject", subject) : subject
  end

  private

  def subject
    subjects = []

    subjects << source.datafields('902').subfields(['a','p','k','s','g','e','t']).values

    # Beispiel aus 740: New York (N.Y.)--Social life and customs--20th century--Fiction.
    %w(710 711 740).each do |f|
      t = source.datafields(f).subfields('a').values
      t = t.flatten.map(&:presence).compact
      t = t.map{|a| a.split('--')}.flatten.map{|s| s.end_with?('.') ? s[0..-2].strip : s}.map(&:presence).compact.uniq
      subjects = subjects + t
    end

    subjects << source.get("Arten des Inhalts").map(&:get)

    subjects.flatten.map(&:presence).compact.map{|f| f.delete('<').delete('>')}.uniq
  end
end
