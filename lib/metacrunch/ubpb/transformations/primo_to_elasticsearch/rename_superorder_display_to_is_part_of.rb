require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../primo_to_elasticsearch"

class Metacrunch::UBPB::Transformations::PrimoToElasticsearch::RenameSuperorderDisplayToIsPartOf < Metacrunch::Transformator::Transformation::Step
  def call
    target.delete("is_part_of") # has to be deleted any way, because there might be old data

    if superorder_display = target.delete("superorder_display")
      Metacrunch::Hash.add(target, "is_part_of", superorder_display)
    end
  end
end
