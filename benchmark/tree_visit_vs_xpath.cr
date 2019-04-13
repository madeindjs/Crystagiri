require "../crystagiri"

def print_table(xpath, xpath_parse, exp, exp_parse)
  puts "method  |  total time | parse time"
  puts "========+=============+============"
  puts "xpath   |  #{xpath}   |  #{xpath_parse}"
  puts "--------+-------------+------------"
  puts "exper.  |   #{exp}   |  #{exp_parse}"
end

def actual_test(url : String)
  # Exclude page load from time monitoring
  response = HTTP::Client.get url
  print "*"
  t = Time.now
  doc = Crystagiri::HTML.new response.body
  parsing_time = Time.now - t
  print "|"
  1..100000.times do |i|
    if i % 10000 == 0
      print "."
    end
    doc.at_tag("div")
    doc.where_class("step-title") { |tag| tag }
    doc.where_class("content") { |tag| tag }
    doc.where_tag("span") { |tag| tag }
  end
  [Time.now - t, parsing_time]
end

def do_test(url : String)
  puts "Running on #{url}"
  Crystagiri::HTML.experimental = false
  result_legacy, parsing_legacy = actual_test url
  
  Crystagiri::HTML.experimental = true
  result_experimental, parsing_exper = actual_test url

  puts
  print_table result_legacy.total_milliseconds, parsing_legacy.total_milliseconds, result_experimental.total_milliseconds, parsing_exper.total_milliseconds
  puts "~"*15
  [result_legacy.total_milliseconds, parsing_legacy.total_milliseconds, result_experimental.total_milliseconds, parsing_exper.total_milliseconds]
end

test_links = [
  "https://www.quirksmode.org/html5/tests/video.html",
  "http://www.8164.org/the-big-table-issue/",
  "https://lawsofux.com/",
  "https://www.youtube.com/"
]

total_legacy = 0
total_parsing_legacy = 0

total_experimental = 0
total_parsing_experimental = 0

test_links.each do | link | 
  legacy, plegacy, experimental, elegacy = do_test link

  total_legacy += legacy
  total_parsing_legacy += plegacy

  total_experimental += experimental
  total_parsing_experimental += elegacy
end

puts "\nTest ran on #{test_links.size} links.\nTime with xpath method: #{total_legacy} ms with #{total_parsing_legacy} ms needed for parsing.\nTime with experimental method: #{total_experimental} ms with #{total_parsing_experimental} ms needed for parsing."