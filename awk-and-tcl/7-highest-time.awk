BEGIN {
	max_time = -1
}

{
	if ($3 == "enter") {
		start[$2] = $1
	}
	else if ($3 == "leave") {
		time = $1 - start[$2]
		if (time > max_time) {
			max_time = time
			max_name = $2
		}
	}
}

END {
	print max_name " spent the most time (" max_time " hours)."
}