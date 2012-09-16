this translations is scraped of the bijbelenkoran.nl website
the following editing has been performed on the text:

- 83:6, 42:19, 5:69 were missing, added them in from a print copy
- around 7:46 was a mistakenly concatenated line
- removed typo'd bismallah from chapter 101 and 73
- fixed some of the issues with questionmarks in VIM with these commands:
  :%s/ ? / -- /g
  :%s/?s /'s /g
  :%s/ ?$/ --/
  :%s/ ?,/ --,/g
  :%s/ ?:/ --:/g
- manually fixed loads of issues with "?" representing "..." or "'"
- fixed problems with "[" in several of the loose letters


the following ruby script was used to scrape:

#!/usr/bin/env ruby
#encodeing: utf-8
require 'open-uri'
require 'nokogiri'
(1..114).each do |i|
  url = "http://www.bijbelenkoran.nl/ayah.php?lIntEntityId=#{i}"
  fn  = "#{i.to_s.rjust(3, '0')}.txt"
  puts ">>> getting #{i}, #{fn} -- #{url}"
  doc = Nokogiri.HTML(open(url).read)
  t = ''
  doc.css('.topPadding12').children.each do |e|
    if e.class == Nokogiri::XML::Text
      txt = e.text.strip
      t << "#{txt}\n" if txt.length > 1 && txt != "In de naam van God, de erbarmer, de barmhartige."
    end
  end
  File.open(fn, 'w') { |f| f.puts t.strip }
end



the files where concatenated with:

touch nl.leemhuis.txt
for f in ???.txt; do cat $f >> nl.leemhuis.txt; done
