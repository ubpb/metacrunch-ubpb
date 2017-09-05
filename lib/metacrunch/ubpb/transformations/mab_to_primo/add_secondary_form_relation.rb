require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddSecondaryFormRelation < Metacrunch::Transformator::Transformation::Step

  def call
    target ? Metacrunch::Hash.add(target, "secondary_form_relation", secondary_form_relation) : secondary_form_relation
  end

private

  def secondary_form_relation
    relations = []

    source.get("Angaben zum Original (Sekundärform)").each do |element|
        relations << relation_factory(element.get, element.get("Identifikationsnummer"))
      end

    relations
  end

  def relation_factory(label, id)
    {
      ht_number: id,
      label: label
    }
    .compact
  end

end
