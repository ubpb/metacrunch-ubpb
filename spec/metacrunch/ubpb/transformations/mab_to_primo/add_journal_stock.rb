describe Metacrunch::UBPB::Transformations::MabToPrimo::AddJournalStock do
  define_field_test "000465037", journal_stock: {:comment=>nil, :leading_text=>nil, :gaps=>["3.1951,11", "9.1955,7-9"], :stock=>["1.1949,3 - 12.1960"], :signature=>"P10/34f6"} # gabs
  define_field_test "001848804", journal_stock: {:comment=>"Nur lfd. u. vorheriger Jahrg. vorh.", :leading_text=>nil, :gaps=>nil, :stock=>nil, :signature=>"P86/10b11"} # comment without stock

  # sorting according to subfield 0
  define_field_test "000450213", journal_stock: [
    {:comment=>"Mikrofiche-Ausg.", :leading_text=>nil, :gaps=>nil, :stock=>["1.1793 - 107.1806"], :signature=>"P92/01d30"},
    {:comment=>"Mikrofiche-Ausg.", :leading_text=>"Anh. zu", :gaps=>nil, :stock=>["1/28.1792/95(1797/1801) - 29/68.1796/1800(1802/03)"], :signature=>"P92/01d30"}
  ]
end
