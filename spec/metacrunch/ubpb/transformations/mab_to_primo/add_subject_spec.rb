describe Metacrunch::UBPB::Transformations::MabToPrimo::AddSubject do
  # << ... >> should be removed
  define_field_test '000972511', subject: ["Vischer, Friedrich Theodor von", "Faust"] # Vischer, Friedrich Theodor &lt;&lt;von&gt;&gt;

  # aus 064a "arten des Inhalts"
  define_field_test '001836826', subject: "Ausstellungskatalog"
  define_field_test '001840251', subject: "Zeitschrift"
  define_field_test '001833425', subject: ["Einführung", "Lehrbuch"]
end
