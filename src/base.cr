require "option_parser"

numbers = [] of String
pad_width = 0
input_base = 10
output_base = 10
output_prefix = ""
no_prefix = false

OptionParser.parse(ARGV) do |parser|
  parser.on("-l WIDTH", "--length=WIDTH", "Padding width") do |padding_width|
    if padding_width.to_i?.nil?
      STDERR.puts "Invalid integer #{padding_width}"
      exit
    end
    pad_width = padding_width.to_i
  end

  parser.on("-i BASE", "--input=BASE", "Input base") do |input_arg|
    if input_arg.to_i?.nil?
      STDERR.puts "Invalid integer #{input_arg}"
      exit
    end
    input_base = input_arg.to_i
  end

  parser.on("-o BASE", "--output=BASE", "Output base") do |output_arg|
    if output_arg.to_i?.nil?
      STDERR.puts "Invalid integer #{output_arg}"
      exit
    end
    output_base = output_arg.to_i
    output_prefix = case output_base
    when 2 then "0b"
    when 8 then "0o"
    when 10 then ""
    when 16 then "0x"
    else raise "Invalid output base"
    end
  end

  parser.on("-P", "--no-prefix", "No prefix") do |_|
    no_prefix = true
  end

  parser.on("-h", "--help", "Print help") do |_|
    puts parser
    exit
  end

  parser.unknown_args() { |args| numbers = args; }
end

if no_prefix
  output_prefix = ""
end

if numbers.empty?
  numbers = STDIN.gets_to_end.lines
end

numbers.each do |num|
  n = nil
  if num.starts_with?("0b")
    n = num[2..num.size].to_i64(2)
  elsif num.starts_with?("0o")
    n = num[2..num.size].to_i64(8)
  elsif num.starts_with?("0x")
    n = num[2..num.size].to_i64(16)
  else
    n = num.to_i64(input_base)
  end

  puts "#{output_prefix}#{n.to_s(output_base).rjust(pad_width, '0')}"
end
