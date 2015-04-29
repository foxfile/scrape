# Scrape Doug Hennig's Technical Articles.
require 'rubygems'
require 'fileutils'
require 'json'
require 'nokogiri'
require 'open-uri'

class Article
  attr_accessor :title
  attr_accessor :folder
  attr_accessor :description
  attr_accessor :pdf_url
  attr_accessor :code_url
end

if !File.exist?('papers.html')
  open('papers.html', 'wb') do |file|
    file << open('http://doughennig.com/papers/').read
  end
end

page = Nokogiri::HTML(open("papers.html"))

articles = Array.new

page.css( "h3" ).each { |tag|
	art = Hash.new
  art_title = tag.text
  next if art_title == "My personal Web site"
	art[:title]  = art_title
	art[:folder] = art_title.gsub(/\?|\!|\'|\:|\,|\.0/,"").gsub(/\s/,"_")

  desc = tag.next_element
  art[:description] = desc.text

  linkspara = desc.next_element
  links = linkspara.css( "a" )
  if links.length > 0
    art[:pdf_url] = links[0]["href"]
    if links.length > 1
      art[:samples_url] = links[1]["href"]
    end
  end

	articles << art
}

File.open("articles.json", 'w') { |file|
	file.write( articles.to_json )
}
