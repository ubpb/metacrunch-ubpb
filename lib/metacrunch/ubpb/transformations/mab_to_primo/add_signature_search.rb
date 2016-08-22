require "metacrunch/hash"
require "metacrunch/transformator/transformation/step"
require_relative "../mab_to_primo"
require_relative "./helpers/signature"

class Metacrunch::UBPB::Transformations::MabToPrimo::AddSignatureSearch < Metacrunch::Transformator::Transformation::Step
  include parent::Helpers::Signature

  def call
    target ? Metacrunch::Hash.add(target, "signature_search", signature_search) : signature_search
  end

  private

  def signature_search
    signatures = []
    signatures = signatures + source.datafields('LOC').subfields(['d', 'f']).values
    # Stücktitel Signatur
    signatures << source.datafields('100', ind2: ' ').subfields('a').value
    # Zeitschriftensignatur
    signatures << source.datafields('200', ind1: ' ', ind2: ' ').subfields('f').values

    # Some cleanup
    signatures = signatures.flatten.map(&:presence).compact.map do |signature|
      _signature = clean_signature(signature)

      # for signatures with volume count e.g. 'LKL2468-14/15', add all variants possible ['LKL2468-14/15', 'LKL2468-14', 'LKL2468']
      [_signature, _signature.gsub(/(\d+)\/\d+\Z/, '\1'), _signature.gsub(/\-\d+.*\Z/, '')]
    end.flatten

    # Erzeuge zu jeder Signatur eine Basis-Signatur
    signatures.map! do |signature|
      [signature, base_signature(signature)]
    end.flatten

    signatures.flatten.map(&:presence).compact.uniq
  end
end
