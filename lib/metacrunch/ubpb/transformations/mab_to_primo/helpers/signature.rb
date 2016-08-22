require_relative "../helpers"

module Metacrunch::UBPB::Transformations::MabToPrimo::Helpers::Signature

  #
  # TWX2230
  # /02c3
  # P 30 / 02 c3
  # P 30 02 c3
  # P30 TWX2230
  #
  def clean_signature(signature)
    return unless signature

    s = signature.gsub(/\s/, "") # Remove whitespaces
    s = s.gsub(/\AP\d\d/, "")    # Remove Standortkennziffer for journals
    s = s.gsub(/\A\//, "")       # Remove leading '/' for journal Stücktitel

    s = s.downcase if journal_signature?(s) # Downcase journal signatures

    s
  end

  def base_signature(signature)
    return unless signature

    index = signature.index('+') || signature.length
    signature[0..index-1]
  end

  def journal_signature?(signature)
    signature.try(:[], /\d\d[a-zA-Z]\d{1,4}/).present?
  end

end


