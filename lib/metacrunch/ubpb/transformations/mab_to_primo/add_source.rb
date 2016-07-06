require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddSource < Metacrunch::Transformator::Transformation::Step

  def call
    target ? Metacrunch::Hash.add(target, "source", record_source) : record_source
  end

  private

  def record_source # source is already taken by the transformation "source"
    [
      source.get("Identifikationsnummern der selbständigen Schrift").first.try(:get),
      [
        [
          source.get("Haupttitel der Quelle").first.try(:get),
          source.get("Verantwortlichkeitsangabe der Quelle").first.try(:get)
        ]
        .compact.join(" / ").presence,
        [
          source.get("Unterreihe der Quelle").first.try(:get),
          source.get("Ausgabebezeichnung der Quelle in Vorlageform").first.try(:get),
          [
            [
              "Verlagsorte der Quelle",
              "Druckorte der Quelle",
              "Vetriebsorte der Quelle",
              "Auslieferungsorte der Quelle"
            ]
            .map do |property|
              source.get(property).map(&:get)
            end
            .flatten.compact.join(", ").presence,
            source.get("Erscheinungsjahr der Quelle").first.try(:get)
          ]
          .compact.join(", ").presence,
        ]
        .compact.join(". - ").presence
      ]
      .compact.join(". ").presence,
      source.get("Reihe der Quelle").first.try(:get).try { |value| "(#{value})" },
      source.get("Zählungen der Quellen").map(&:get).join(", ")
    ]
    .try do |ht_number, label, volume, counting|
      {
        ht_number: ht_number,
        label: label,
        volume: volume,
        counting: counting
      }
    end
    .try do |result|
      result.to_json
    end
  end
end
