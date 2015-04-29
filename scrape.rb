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
  attr_accessor :article_url
  attr_accessor :samples_url
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
	art[:title]  = tag.text
	art[:folder] = tag.text.gsub(/\?|\!|\'|\:|\,|\.0/,"").gsub(/\s/,"_")
	articles << art
}

File.open("articles.json", 'w') { |file|
	file.write( articles.to_json )
}
