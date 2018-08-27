require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"
require_relative "./add_signature_search"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddSuperorderDisplayForSammlungWolff < Metacrunch::Transformator::Transformation::Step

  def call
    target ? Metacrunch::Hash.add(target, "superorder_display", superorder_display) : superorder_display
  end

  private

  def superorder_display
    superorders = []

    if signature_search.include?("ZZVW1009")
      superorders << {
        ht_number: nil,
        label: "Sammlung Wolff",
        volume_count: nil,
        label_additions: nil
      }
    end

    superorders.map(&:to_json)
  end

  def signature_search
    target.try(:[], "signature_search") || self.class.parent::AddSignatureSearch.new(source: source).call
  end
end
