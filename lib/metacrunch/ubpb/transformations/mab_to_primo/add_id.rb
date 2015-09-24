require "mighty_hash"
require "transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddId < Transformator::Transformation::Step
  def call
    target ? MightyHash.add(target, "id", id) : id
  end

  private

  def id
    source.controlfield('SYS').values.join
  end
end
