set file [open "prime.txt" "w"]

set limit 1000
set counter 2
set number 2


for {set number 2} {$number < $limit} {incr number} {
	set half [expr sqrt($number)]
	set is_prime true
	for {set counter 2} {$counter < $half} {incr counter} {
		if { $counter != $number && $number % $counter == 0} {
			set is_prime false
			break
		}
	}
	if ($is_prime) {
		puts $number
		puts -nonewline $file "$number "
		incr index
	}
}


close $file