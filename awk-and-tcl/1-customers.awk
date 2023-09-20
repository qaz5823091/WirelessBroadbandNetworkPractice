BEGIN {
	counter = 0
}

{
	if ($3 == "enter") {
		counter = counter + 1
	}
}

END {
	print "There are " counter " customers in the resturant."
}