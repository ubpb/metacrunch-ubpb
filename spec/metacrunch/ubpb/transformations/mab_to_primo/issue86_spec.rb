describe "issue86" do
  define_field_test "000308120", journal_stock: [
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["1578/1945(1992)", "1946/79(2002)", "1980/81(1988)", "1982/83(1985) - 1988/89(1991)", "1990/94(1999)", "1995/2010(2015)"], :signature=>"LUHP1330"},
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["1578/1945(1992)", "1946/79(2002)", "1980/81(1988)", "1982/83(1985) - 1988/89(1991)", "1990/94(1999)", "1995/2010(2015)"], :signature=>"LUHP1893"}
  ]

  define_field_test "000308120", signature_search: ["LUHP1893", "LUHP1893-1578/1945", "LUHP1893-1578", "LUHP1893-1946/79", "LUHP1893-1946", "LUHP1330"]

  define_field_test "000313824", journal_stock: [
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["1.1973 - 34.2006"], :signature=>"01b6"},
    {:comment=>nil, :leading_text=>"Sonderh. zu", :gaps=>nil, :stock=>["[N.F.] 9.2015"], :signature=>"01b6"}
  ]

  define_field_test "000313824", signature_search: "01b6"

  define_field_test "000322088", journal_stock: [
    {:comment=>"Microfiches", :leading_text=>nil, :gaps=>nil, :stock=>["1.1981 - 2.1982"], :signature=>"36l2"},
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["3.1983 - 10.1990"], :signature=>"36l2"}
  ]

  define_field_test "000695312", journal_stock: [
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["2.1995"], :signature=>"34o3"},
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["2.1995"], :signature=>"34o3"}
  ]

  define_field_test "001515570", journal_stock: [
    {:comment=>nil, :leading_text=>"Nr.", :gaps=>nil, :stock=>["14/17.2006", "26.2009 -"], :signature=>"28g4"},
    {:comment=>nil, :leading_text=>"CD-Beilage zu Nr.", :gaps=>nil, :stock=>["28.2009 -"], :signature=>"28g4"},
    {:comment=>nil, :leading_text=>"Materialien zu Nr.", :gaps=>nil, :stock=>["14/17.2006", "26.2009 -"], :signature=>"28g4"}
  ]
end
