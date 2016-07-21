require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddJournalStock < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "journal_stock", journal_stock) : journal_stock
  end

  private

  def journal_stock
    source.datafields("200", ind1: " ")
    .map do |datafield|
      {
        "Einleitender Text (NW)" => datafield.subfields("a").value,
        "Zusammenfassende Bestandsangabe (NW)" => datafield.subfields("b").value,
        "Lückenangabe (allgemein) (NW)" => datafield.subfields("c").value,
        "Lückenangabe (Desideratenverzeichnisse) (NW)" => datafield.subfields("d").value,
        "Kommentar (NW)" => datafield.subfields("e").value,
        "Magazin- / Grundsignatur (NW)" => datafield.subfields("f").value,
        "Kommentar zur Grundsignatur (NW)" => datafield.subfields("k").value,
        "Sortierhilfe (NW)" => datafield.subfields("0").value,
        #
        # below are not set/used according to Vera
        #
        "(Sonder-) Standort (NW)" => datafield.subfields("g").value,
        "(Sonder-) Standortsignatur (NW)" => datafield.subfields("h").value,
        "Ausleihindikator (NW)" => datafield.subfields("m").value,
        "SUBITO-Lieferbedingungen (NW)" => datafield.subfields("n").value
      }
    end
    .sort do |a,b|
      (a.fetch("Sortierhilfe (NW)") || "0") <=> (b.fetch("Sortierhilfe (NW)") || "0") # very few records need the "0" default
    end
    .map do |field|
      {
        comment: field.fetch("Kommentar (NW)"),
        leading_text: field.fetch("Einleitender Text (NW)").try(:sub, /\A-\s+/, ""), # remove "- " which is sometimes prepended
        gaps: field.fetch("Lückenangabe (allgemein) (NW)").try(:sub, /\A\[N=/, "").try(:sub, /\]\Z/, "").try(:split, ";").try(:map, &:strip),
        stock: field.fetch("Zusammenfassende Bestandsangabe (NW)").try(:split, ";").try(:map, &:strip),
        signature: field.fetch("Magazin- / Grundsignatur (NW)").try(:gsub, /\s/, "")
      }
    end
    .presence
  end
end
