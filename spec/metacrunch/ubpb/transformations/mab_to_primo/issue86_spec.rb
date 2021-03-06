describe "issue86" do
  define_field_test "000308120", journal_stock: [
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["1578/1945(1992)", "1946/79(2002)", "1980/81(1988)", "1982/83(1985) - 1988/89(1991)", "1990/94(1999)", "1995/2010(2015)"], :signature=>"P38LUHP1330"}, 
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["1578/1945(1992)", "1946/79(2002)", "1980/81(1988)", "1982/83(1985) - 1988/89(1991)", "1990/94(1999)", "1995/2010(2015)"], :signature=>"P28LUHP1893"}
  ]

  define_field_test "000308120", signature_search: ["LUHP1893", "LUHP1893-1578/1945", "LUHP1893-1578", "LUHP1893-1946/79", "LUHP1893-1946", "LUHP1330", "P38LUHP1330", "P28LUHP1893"]

  define_field_test "000313824", journal_stock: [
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["1.1973 - 34.2006"], :signature=>"P10/01b6"},
    {:comment=>nil, :leading_text=>"Sonderh. zu", :gaps=>nil, :stock=>["[N.F.] 9.2015"], :signature=>"P02/01b6"}
  ]

  define_field_test "000313824", signature_search: ["01B6", "01 B 6", "P02/01B6", "P 02/01 B 6", "P10/01B6", "P 10/01 B 6"]

  define_field_test "000322088", journal_stock: [
    {:comment=>"Microfiches", :leading_text=>nil, :gaps=>nil, :stock=>["1.1981 - 2.1982"], :signature=>"P92/36l2"},
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["3.1983 - 10.1990"], :signature=>"P10/36l2"}
  ]

  define_field_test "000695312", journal_stock: [
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["2.1995"], :signature=>"P10/34o3"},
    {:comment=>nil, :leading_text=>nil, :gaps=>nil, :stock=>["2.1995"], :signature=>"P11/34o3"}
  ]

  define_field_test "001515570", journal_stock: [
    {:comment=>nil, :leading_text=>"Nr.", :gaps=>nil, :stock=>["14/17.2006", "26.2009 -"], :signature=>"P10/28g4"},
    {:comment=>nil, :leading_text=>"CD-Beilage zu Nr.", :gaps=>nil, :stock=>["28.2009 -"], :signature=>"P96/28g4"},
    {:comment=>nil, :leading_text=>"Materialien zu Nr.", :gaps=>nil, :stock=>["14/17.2006", "26.2009 -"], :signature=>"P02/28g4"}
  ]
end
