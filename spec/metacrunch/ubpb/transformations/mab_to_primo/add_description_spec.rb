describe Metacrunch::UBPB::Transformations::MabToPrimo::AddDescription do

  define_field_test '405',     description: 'XXX: YYY'
  define_field_test '522',     description: 'XXX: YYY'
  define_field_test '523',     description: 'XXX: YYY'
  define_field_test '501-519', description: ["AAA", "XXX: YYY"]
  define_field_test '536-537', description: ["BBB", "YYY"]

  # Exclude 537 for journals (ubpb/catalog#290, ubpb/catalog#405)
  define_field_test '001510737', description: "1981(1982) - 2001(2002)"

  # regression tests for mab2 dsl
  define_field_test '001249913', description: [
    "Orig.: D 2007. - Freigegeben ab 12 Jahren",
    "Sprachen: dt. Fassung (auch für Hörgeschädigte) / türk. Fassung",
    "Untertitel: dt.",
    "Bonus-Disc: Regiekommentar, Statements von Regisseur und Schauspielern",
    "Freigegeben ab 12 Jahren"
  ]

  define_field_test '001843620', description: "Sonderdruck"
  define_field_test '001214891', description: [
    "2009,Mai -",
    "Hauptsacht. anfangs: NWB",
    "Gesehen am 01.12.15",
    "Die Datenbank enthält verschiedenen Module zu Steuer- und Wirtschaftsrecht"
  ]
end
