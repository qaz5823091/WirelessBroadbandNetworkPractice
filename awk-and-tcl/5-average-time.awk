BEGIN {
	counter = 0
	sum_time = 0
}

{
	if ($3 == "enter") {
		counter = counter + 1
		start[$2] = $1
	}
	else if ($3 == "leave") {
		sum_time = sum_time + ($1 - start[$2])
	}
}

END {
	print "The average cost-time is " (sum_time / counter) " (hrs/person)."
}