BEGIN {
	max_cost = -1
}

{
	if ($3 == "pay") {
		if ($4 > max_cost) {
			max_cost = $4
			max_name = $2
		}
	}
}

END {
	print max_name " spent the most money ($" max_cost ")."
}