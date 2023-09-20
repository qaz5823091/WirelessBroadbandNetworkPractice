BEGIN {
	counter = 0
	sum_cost = 0
}

{
	if ($3 == "enter") {
		counter = counter + 1
	}
	else if ($3 == "pay") {
		sum_cost = sum_cost + $4
	}
}

END {
	print "The average cost is " (sum_cost / counter) "."
}