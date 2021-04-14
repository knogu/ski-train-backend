require 'open-uri'

namespace :scrape do
  desc '東京から越後湯沢、平日'
  task :tokyo2echigoyuzawa => :environment do
    url = 'https://www.jreast-timetable.jp/2104/timetable/tt1039/1039050.html'

    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    doc.search('.station_name01').each do |link|
      puts link.content
    end
  end
end
