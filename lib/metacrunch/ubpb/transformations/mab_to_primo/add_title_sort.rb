require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"
require_relative "./add_title"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddTitleSort < Metacrunch::Transformator::Transformation::Step
  def call
    Metacrunch::Hash.add(target, "title_sort", title_sort)
  end

  private

  def title_sort
    title
    .gsub(/<<.*>>/, "")
    .gsub(/[-\/]/, " ")
    .gsub(/[^A-Za-z0-9\sÄÖÜäöüß]/, "")
    .gsub(/\s{2,}/, " ")
    .strip
    .downcase
    .gsub("Ä", "a") # Ruby cannot downcase german umlauts on its own + these should be sorted
    .gsub("Ö", "o") # alongside with a/o/u
    .gsub("Ü", "u")
    .gsub("ä", "a")
    .gsub("ö", "o")
    .gsub("ü", "u")
    .gsub("ß", "ss")
  end

  private

  def title
    target.try(:[], "title") || self.class.parent::AddTitle.new(source: source).call
  end
end
