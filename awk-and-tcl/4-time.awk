{
	if ($3 == "enter") {
		start[$2] = $1
	}
	else if ($3 == "leave") {
		print $2 " spent " ($1 - start[$2]) " hours in the resturant."
	}
}