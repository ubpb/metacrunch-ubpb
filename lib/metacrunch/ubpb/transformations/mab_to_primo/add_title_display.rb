require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"
require_relative "./helpers/datafield_089"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddTitleDisplay < Metacrunch::Transformator::Transformation::Step
  include parent::Helpers::Datafield089

  def call
    target ? Metacrunch::Hash.add(target, "title_display", title_display) : title_display
  end

  private

  def title_display
    # Werk
    hauptsachtitel_des_werks_in_ansetzungsform = source.datafields("310", ind2: [:blank, "1"]).value
    hauptsachtitel_des_werks_in_vorlageform = source.datafields("331", ind2: [:blank, "1"]).value
    hauptsachtitel_des_werks = hauptsachtitel_des_werks_in_ansetzungsform || hauptsachtitel_des_werks_in_vorlageform
    allgemeine_matieralbenennung_des_werks = source.datafields("334", ind2: [:blank, "1"]).value
    zusätze_zum_hauptsachtitel_des_werks = source.datafields("335", ind2: [:blank, "1"]).value
    bandangabe_des_werks = datafield_089.value

    # Überordnung
    hauptsachtitel_der_überordnung_in_ansetzungsform = source.datafields("310", ind2: "2").value
    hauptsachtitel_der_überordnung_in_vorlageform = source.datafields("331", ind2: "2").value
    hauptsachtitel_der_überordnung = hauptsachtitel_der_überordnung_in_ansetzungsform || hauptsachtitel_der_überordnung_in_vorlageform

    zusätze_zum_hauptsachtitel_der_überordnung = source.datafields("335", ind2: "2").value
    ausgabebezeichnung_der_überordnung = source.datafields("403", ind2: "2").value

    if hauptsachtitel_der_überordnung && hauptsachtitel_des_werks
      [].tap do |_result|
        _result << titel_factory(hauptsachtitel_der_überordnung, {
          zusätze_zum_hauptsachtitel: zusätze_zum_hauptsachtitel_der_überordnung
        })

        if bandangabe_des_werks
          # füge den Band nicht hinzu, wenn das Werk genauso heißt, bsp. "Anleitungen eine Farbe zu lesen / <rot> : Rot"
          if bandangabe_des_werks.gsub(/<|>/, "").downcase != hauptsachtitel_des_werks.downcase
            _result << "/"
            _result << bandangabe_des_werks
          end
        end

        _result << ":"
        _result << titel_factory(hauptsachtitel_des_werks, {
          zusätze_zum_hauptsachtitel: zusätze_zum_hauptsachtitel_des_werks,
          allgemeine_materialbenennung: allgemeine_matieralbenennung_des_werks
        })
      end
      .compact
      .join(" ")
    elsif !hauptsachtitel_der_überordnung && hauptsachtitel_des_werks
      titel_factory(hauptsachtitel_des_werks, {
        zusätze_zum_hauptsachtitel: zusätze_zum_hauptsachtitel_des_werks,
        bandangabe: bandangabe_des_werks,
        allgemeine_materialbenennung: allgemeine_matieralbenennung_des_werks
      })
    elsif hauptsachtitel_der_überordnung && !hauptsachtitel_des_werks
      [].tap do |_result|
        _result << titel_factory(hauptsachtitel_der_überordnung, {
          zusätze_zum_hauptsachtitel: zusätze_zum_hauptsachtitel_der_überordnung,
          ausgabebezeichnung: ausgabebezeichnung_der_überordnung
        })

        _result << bandangabe_des_werks if bandangabe_des_werks
      end
      .compact
      .join(" ")
    end
    .try(:gsub, /<<|>>/, "")
  end

  private

  def titel_factory(hauptsachtitel, options = {})
    ausgabebezeichnung = options[:ausgabebezeichnung]
    bandangabe = options[:bandangabe]
    zusätze_zum_hauptsachtitel = options[:zusätze_zum_hauptsachtitel]
    unterreihen = source.datafields("360", ind2: "1").subfields("a").values
    allgemeine_materialbenennung = options[:allgemeine_materialbenennung]

    arten_des_inhalts = source.get("Arten des Inhalts").map(&:get)
    erweiterte_datenträgertypen = source.get("erweiterte Datenträgertypen").map(&:get)

    if hauptsachtitel
      result =[]

      result <<
      [
        hauptsachtitel,
        unterreihen.select do |unterreihe|
          unterreihe.split.none? do |string|
            hauptsachtitel.include?(string)
          end
        end
      ]
      .flatten
      .compact
      .join(". ")

      if zusätze_zum_hauptsachtitel
        result << ": #{zusätze_zum_hauptsachtitel}"
      end

      if ausgabebezeichnung
        result << "- #{ausgabebezeichnung}"
      end

      if bandangabe
        result << ": #{bandangabe}"
      end

      additions =
      [
        allgemeine_materialbenennung,
        #arten_des_inhalts,
        erweiterte_datenträgertypen
      ]
      .flatten
      .compact
      .uniq
      .join(", ")
      .presence

      if additions
        result << "[#{additions}]"
      end

      result.join(" ")
    end
  end

  # References
  # - http://www.payer.de/rakwb/rakwb00.htm
end
