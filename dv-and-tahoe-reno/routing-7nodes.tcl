set ns [new Simulator]

if {$argc==1} {
	set par [lindex $argv 0]
	if {$par=="DV"} {
		$ns rtproto DV
	}
}

$ns color 1 Blue

set file1 [open out.nam w]
$ns namtrace-all $file1

proc finish {} {
        global ns file1
        $ns flush-trace
        close $file1
        exec nam out.nam &
        exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n0 $n1 0.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 10ms DropTail
$ns duplex-link $n1 $n3 0.5Mb 10ms DropTail
$ns duplex-link $n3 $n4 0.5Mb 10ms DropTail
$ns duplex-link $n3 $n2 0.5Mb 10ms DropTail
$ns duplex-link $n1 $n5 0.5Mb 10ms DropTail
$ns duplex-link $n5 $n6 0.5Mb 10ms DropTail
$ns duplex-link $n6 $n3 0.5Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n1 $n3 orient down
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n3 $n2 orient right-up
$ns duplex-link-op $n1 $n5 orient right-up
$ns duplex-link-op $n3 $n6 orient right-up
 
set tcp [new Agent/TCP]
$tcp set fid_ 1
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ns rtmodel-at 1.0 down $n1 $n3

$ns rtmodel-at 1.3 down $n1 $n2

$ns rtmodel-at 1.6 up $n1 $n2

$ns rtmodel-at 2.0 up $n1 $n3

$ns at 0.1 "$ftp start"

$ns at 3.0 "finish"

$ns run
