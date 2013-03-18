require "open-uri"

options = {
	"Accept-Language" => "en;q=0.5"	
}

open("http://www.ruby-lang.org",options){|io|	
	puts io.read
}

