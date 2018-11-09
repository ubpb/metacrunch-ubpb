require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../primo_to_elasticsearch"

class Metacrunch::UBPB::Transformations::PrimoToElasticsearch::AddCatalogingDate < Metacrunch::Transformator::Transformation::Step
  def call
    if (last_creation_date = [source["creation_date"]].flatten.compact.last)
      begin
        if cataloging_date = Date.strptime(last_creation_date, "%Y%m%d").iso8601
          target["cataloging_date"] = cataloging_date
        end
      rescue ArgumentError
      end
    end
  end
end
