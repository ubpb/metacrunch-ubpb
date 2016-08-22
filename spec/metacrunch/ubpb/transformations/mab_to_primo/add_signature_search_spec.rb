describe Metacrunch::UBPB::Transformations::MabToPrimo::AddSignatureSearch do
  # Zeitschriftensignaturen
  define_field_test '000321365', signature_search: "34k12"
  define_field_test '000636652', signature_search: "34m3"
  define_field_test '000857994', signature_search: "34t26"
  define_field_test '000452919', signature_search: "49s105"

  define_field_test '000859176', signature_search: "KDVD1105"
  define_field_test '000969442', signature_search: ["TWR12765+4", "TWR12765", "TWR12765+1", "TWR12765+2", "TWR12765+3"]

  define_field_test '000765779', signature_search: "34t24"
  define_field_test '000869906', signature_search: "34t24"
  define_field_test '001414237', signature_search: "34t24"

  # Signatur mit anhängiger Bandzählung
  define_field_test '000161445', signature_search: ["KXW4113-80/81", "KXW4113-80", "KXW4113"]
  define_field_test '001006945', signature_search: ["LKL2468-14", "LKL2468"]

  # UV183
  define_field_test '000318290', signature_search: "43g18" # Geographie heute
  define_field_test '000897969', signature_search: "40p8"  # Praxis Geschichte
  define_field_test '000998195', signature_search: "40p8"  # Praxis Geschichte [Elektronische Ressource]
  define_field_test '001518782', signature_search: "43g18" # Geographie heute

  # missing subfield 0
  define_field_test '000695094', signature_search: "49p30"

  # add signature from LOC subfield f
  define_field_test '000062467', signature_search: ["M41972", "BPOF1032", "BPOF1032+1", "ZZVS1009"]

  # https://github.com/ubpb/issues/issues/54
  define_field_test '000517673', signature_search: ["CSCB6417+1", "CSCB6417"]
end
