require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddOclcId < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "oclc_id", oclc_id) : oclc_id
  end

  private

  def oclc_id
    oclc_ids = []
    oclc_ids << source.datafields('025', ind1: 'o',  ind2: '1').subfields('a').values
    oclc_ids.flatten.map(&:presence).compact.uniq
  end
end
