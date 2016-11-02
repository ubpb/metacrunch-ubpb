describe Metacrunch::UBPB::Transformations::MabToPrimo::AddTitleSort do
  # << ... >> should be removed
  define_field_test '000954111', title_sort: "kitakant igaku kitakanto medical journal"
  define_field_test '000992332', title_sort: "hexenbürgermeister von lemgo ein lesedrama in versen"

  # https://github.com/ubpb/issues/issues/80
  define_field_test '000958271', title_sort: "amerikanisierung deutscher unternehmen wettbewerbsstrategien und unternehmenspolitik bei henkel siemens und daimler benz 1945 49 1975"
  define_field_test '000944420', title_sort: "deutsches modell oder globalisiertes arrangement transformation industrieller beziehungen und soziale nachhaltigkeit"
  define_field_test '001761168', title_sort: "deutschland ag historische annäherungen an den bundesdeutschen kapitalismus"
  define_field_test '000949650', title_sort: "dream city ein münchner gemeinschaftsprojekt 25 märz bis 20 juni 1999 kunstraum münchen kunstverein münchen museum villa stuck siemens kulturprogramm"
  define_field_test '000950178', title_sort: "unsere verwaltung treibt einer katastrophe zu das reichsministerium für die besetzten ostgebiete und die deutsche besatzungsherrschaft in der sowjetunion 1941 1945"
  define_field_test '001840068', title_sort: "wir können auch anders gefährlichen entwicklungen bei schülern entgegenwirken"
  define_field_test '000612658', title_sort: "made in germany the corporate identity of a nation"
  define_field_test '000603692', title_sort: "aspekte interkulturellen managements 1 1992"
  define_field_test '001840670', title_sort: "100 nachhaltigkeits cr kennzahlen"
  define_field_test '001422170', title_sort: "okonomischer patriotismus in zeiten regionaler und internationaler integration zur problematik staatlicher aufsicht über grenzüberschreitende unternehmensübernahmen"
end
