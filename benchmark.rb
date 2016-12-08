require "nokogiri"
t1 = Time.now
doc = Nokogiri::HTML File.read("spec/fixture/HTML.html")
1..100000.times do
  doc.at_css("h1")
  doc.css(".step-title"){|tag| tag}
end
puts "executed in #{Time.now - t1} seconds"