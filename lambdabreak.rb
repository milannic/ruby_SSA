def test
	puts "entering test method"
	lambda = lambda{puts "entering lambda"; break; puts "exiting lambda"}
	lambda.call
	puts "exiting test methdod"
end
test
