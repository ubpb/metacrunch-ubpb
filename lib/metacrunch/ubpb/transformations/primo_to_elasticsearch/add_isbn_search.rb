require "isbn"
require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../primo_to_elasticsearch"

class Metacrunch::UBPB::Transformations::PrimoToElasticsearch::AddIsbnSearch < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "isbn_search", isbn_search) : isbn_search
  end

  private

  def isbn_search
    search_isbns = []

    isbns.each do |isbn|
      search_isbns << isbn

      isbn_no_dashes = isbn.gsub("-", "")
      search_isbns << isbn_no_dashes

      isbn_10 = begin
        ISBN.as_ten(isbn_no_dashes)
      rescue RuntimeError ; nil end
      search_isbns << isbn_10 if isbn_10

      isbn_13 = begin
        ISBN.as_thirteen(isbn_no_dashes)
      rescue RuntimeError ; nil end
      search_isbns << isbn_13 if isbn_13
    end

    search_isbns.uniq
  end

  def isbns
    [source["isbn"]].flatten.compact
  end
end
