require 'benchmark/ips'
STRING_HASH  = { "foo"  => "bar" }
SYMBOL_HASH  = { :foo   => "bar" }
INTEGER_HASH = { 1      => "bar" }
Benchmark.ips do |x|
  x.report("String") { STRING_HASH["foo"] }
  x.report("Symbol") { SYMBOL_HASH[:foo] }
  x.report("Integer") { INTEGER_HASH[1] }
  x.compare!
end