require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddCollectionCode < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "collection_code", collection_code) : collection_code
  end

  private

  def collection_code
    source.datafields('LOC', ind2: :blank).subfields('b').values.flatten.map(&:presence).compact.uniq
  end
end
