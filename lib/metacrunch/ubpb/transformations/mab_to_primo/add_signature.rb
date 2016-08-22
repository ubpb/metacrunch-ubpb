require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"
require_relative "./helpers/signature"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddSignature < Metacrunch::Transformator::Transformation::Step
  include parent::Helpers::Signature

  def call
    target ? Metacrunch::Hash.add(target, "signature", signature) : signature
  end

  private

  def signature
    signatures = []

    # Lade LOC Felder für Signaturen-Extraktion
    fields = source.datafields('LOC')
    # Lösche alle Felder die kein Unterfeld d haben (ausgesondert)
    fields = fields.reject{|f| f.subfields.find{|sf| sf.code == "d"}.blank?}
    # Prüfe ob alle Exemplare im Magazin stehen
    all_stack = fields.map{|f| f.subfields.find {|sf| sf.code == 'b' && sf.value.match(/02|03|04|07/)}.present?}.all?

    # Zeitschriftensignatur (haben Vorrgang, falls vorhanden)
    #
    # Achtung, bei Feld 200 handelt es sich um einen Aleph-Expand. Dieses Feld ist an den beiden leeren Indikatoren zu erkennen.
    # Darüber hinaus kann dieses Feld mehrfach vorkommen. Wir nehmen an, dass Subfeld 0 eine Art Zählung angibt, weshalb dort
    # ein Wert von '1' zu bevorzugen ist.
    #
    signatures << source.datafields('200', ind1: ' ', ind2: ' ')
    .select { |f| f.subfields('f').present?                  }
    .select { |f| (value = f.subfields('0').value) == '1' || value.nil? }
    .map    { |f| f.subfields('f').value.try(:gsub, ' ', '') }
    .first.presence

    # Wenn alle Exemplare im Magzin stehen, dann nimm nur die erste signatur
    if all_stack
      fields.each do |field|
        subfield = field.subfields.find{|f| f.code == "d"}
        if subfield.present? && subfield.value.present?
          signatures << subfield.value
          break
        end
      end
    else # ansonsten extrahiere aus den normalen Signaturen eine Basis-Signatur
      # Lösche alle Felder die als Standordkennziffer eine Magazinkennung haben
      fields = fields.reject{|f| f.subfields.find{|sf| sf.code == 'b' && sf.value.match(/02|03|04|07/)}.present?}

      # Sortiere die restlichen Felder nach Unterfeld 5 (Strichcode)
      fields = fields.sort do |x, y|
       x5 = x.subfields.find{|f| f.code == "5"}
       y5 = y.subfields.find{|f| f.code == "5"}
       if x5 && y5
         x5.value <=> y5.value
       else
         0
       end
      end

      # Extrahiere die Signaturen aus Unterfeld d und erzeuge eine Basis-Signatur
      fields.each do |field|
        field.subfields(["d", "f"]).each do |_subfield|
          if _subfield.value.present?
            signature = _subfield.value
            signatures << base_signature(signature)
          end
        end
      end
    end

    # Stücktitel Signatur
    signatures << source.datafields('100', ind2: ' ').subfields('a').value

    # Final cleanup
    signatures = signatures.map{|s| clean_signature(s)}

    # Fertig. Wir nehmen die erste Signatur zur Anzeige
    signatures.flatten.map(&:presence).compact.uniq.first
  end
end
