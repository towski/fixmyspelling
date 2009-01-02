require 'rubygems'
require 'sinatra'
require 'activesupport'
require 'hashish'
require 'config'

class Speller
	def self.fix phrase
	  corrections = google(phrase)["spellresult"]["c"]
		if corrections.kind_of? Hash
			corrections = [corrections]
		elsif corrections == nil
			corrections = []
		end
	  words = phrase.split
		corrections.each do |hash|
			appendum = ''
			word = phrase[hash["o"].to_i, hash["l"].to_i]
			index = words.index(word)
			index = words.index("#{word}#{appendum = '.'}") unless index
			index = words.index("#{word}#{appendum = ','}") unless index
			return "Couldn't find word #{word}" unless index
			words[index] = hash["content"].split("\t").first + appendum
		end
		words.join(" ")
	end

	def self.google phrase
		phrase.gsub!(/'/,'')
	  result = `curl -X POST "https://www.google.com/tbproxy/spell?lang=en&amp;hl=en" -d '<?xml version="1.0" encoding="utf-8" ?><spellrequest textalreadyclipped="0" ignoredups="0" ignoredigits="1" ignoreallcaps="1"><text>#{phrase}</text></spellrequest>' 2> /dev/null`
		Hash.from_xml(result, true)
	end
end

get '/' do
	<<-EOF
	<html>
	<body>
		Fix my spelling:
		<form method='POST'>
			<input type='text' name='text'/>
		</form>
	</body>
	</html>
	EOF
end

post "/" do
	Speller.fix params[:text]
end
