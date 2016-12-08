require "./src/crystagiri"
t = Time.now
doc = Crystagiri::HTML.from_file "./spec/fixture/HTML.html"
1..100000.times do
  doc.at_css("h1")
  doc.css(".step-title") { |tag| tag }
end
puts "executed in #{Time.now - t} seconds"
