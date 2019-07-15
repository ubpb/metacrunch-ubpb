require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddCreatorContributorSearch < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "creator_contributor_search", creator_contributor_search) : creator_contributor_search
  end

  private

  def creator_contributor_search
    [
      source.get("Körperschaften", include: "Überordnungen").map(&:get),
      source.get("Körperschaften (Phrasenindex)", include: "Überordnungen").map(&:get),
      source.get("Personen", include: "Überordnungen").map(&:get),
      source.get("Personen (Phrasenindex)", include: "Überordnungen").map(&:get),
      source.get("Personen der Nebeneintragungen", include: "Überordnungen").map(&:get)
    ]
    .flatten
    .compact
    .uniq
  end
end
