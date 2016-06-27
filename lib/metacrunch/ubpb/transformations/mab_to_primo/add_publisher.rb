require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddPublisher < Metacrunch::Transformator::Transformation::Step
  def call
    target ? Metacrunch::Hash.add(target, "publisher", publisher) : publisher
  end

  private

  def publisher
    publisher = []

    is_rda_record = source.datafields('419').present?

    if is_rda_record
      source.datafields('419').each do |_veröffentlichungsangabe|
        verlagsorte = _veröffentlichungsangabe.subfields('a').value.try(:strip)
        verlagsname = _veröffentlichungsangabe.subfields('b').value
        reihenfolge =
        case _veröffentlichungsangabe.subfields('A').value.try(:to_i)
        #when 2 then "intervenierende Angabe"
        when 3 then "laufende/letze Angabe"
        end

        publisher << [
          [verlagsorte, verlagsname].compact.join(" : "),
          reihenfolge.present? ? "[#{reihenfolge}]" : nil
        ].compact.join(" ")
      end
    else # is rak record
      orte_der_ersten_verleger                  = source.datafields('410', ind2: '1').subfields('a').values.presence
      orte_der_ersten_verleger_der_überordnung  = source.datafields('410', ind2: '2').subfields('a').values.presence
      orte_der_zweiten_verleger                 = source.datafields('415', ind2: '1').subfields('a').values.presence
      orte_der_zweiten_verleger_der_überordnung = source.datafields('415', ind2: '2').subfields('a').values.presence

      orte_der_ersten_verleger  ||= orte_der_ersten_verleger_der_überordnung
      orte_der_zweiten_verleger ||= orte_der_zweiten_verleger_der_überordnung

      namen_der_ersten_verleger                  = source.datafields('412', ind2: '1').subfields('a').values.presence
      namen_der_ersten_verleger_der_überordnung  = source.datafields('412', ind2: '2').subfields('a').values.presence
      namen_der_zweiten_verleger                 = source.datafields('417', ind2: '1').subfields('a').values.presence
      namen_der_zweiten_verleger_der_überordnung = source.datafields('417', ind2: '2').subfields('a').values.presence

      namen_der_ersten_verleger  ||= namen_der_ersten_verleger_der_überordnung
      namen_der_zweiten_verleger ||= namen_der_zweiten_verleger_der_überordnung

      # ... weitere Verleger in 418 ohne Ortsangabe ignorieren wir

      erste_verleger = namen_der_ersten_verleger
      .try(:map).try(:with_index) do |_name_eines_ersten_verlegers, _index|
        [orte_der_ersten_verleger.try(:[], _index), _name_eines_ersten_verlegers].compact.join(" : ")
      end

      zweite_verleger = namen_der_zweiten_verleger
      .try(:map).try(:with_index) do |_name_eines_zweiten_verlegers, _index|
        [orte_der_zweiten_verleger.try(:[], _index), _name_eines_zweiten_verlegers].compact.join(" : ")
      end

      publisher.concat(erste_verleger) if erste_verleger.present?
      publisher.concat(zweite_verleger) if zweite_verleger.present?
    end

    publisher.map! { |_verleger| _verleger.gsub(/<<|>>/, '') }
  end
end
