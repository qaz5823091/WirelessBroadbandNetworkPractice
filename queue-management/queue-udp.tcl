if {$argc !=2} {
	puts "Usage: ns queue.tcl queuetype_ noflows_ "
	puts "Example:ns queue.tcl myfifo 10"
	puts "queuetype_: myfifo or RED"
	exit
}

set par1 [lindex $argv 0]
set par2 [lindex $argv 1]

# 產生一個模擬的物件
set ns [new Simulator]

#開啟一個trace file，用來記錄封包傳送的過程
set nd [open out-$par1-$par2.tr w]
$ns trace-all $nd

#定義一個結束的程序
proc finish {} {
	global ns nd par2 tcp startT
        $ns flush-trace
        close $nd 
              
    	set time [$ns now]
    	set sum_thgpt 0
  
  	#throughput = 收到Ack數 * Packet Size (Bit) / 傳送時間
  	#收到Ack數 = 傳送出Packet數
#     	for {set i 0} {$i < $par2} {incr i} {
#     		set ackno_($i) [$tcp($i) set ack_]
#     		set thgpt($i) [expr $ackno_($i) * 1000.0 * 8.0 / ($time - $startT($i)) ]
#     		#puts $thgpt($i)
#     		set sum_thgpt [expr $sum_thgpt+$thgpt($i)]
#     	}
#     	
#     	set avgthgpt [expr $sum_thgpt/$par2]
#     	puts "average throughput: $avgthgpt (bps)"
    	exit 0
}


for {set i 0} {$i < $par2} {incr i} {
	set src($i) [$ns node]
	set dst($i) [$ns node]
}

#產生兩個路由器
set r1 [$ns node]
set r2 [$ns node]

#把節點和路由器連接起來
for {set i 0} {$i < $par2} {incr i} {
	$ns duplex-link $src($i) $r1 100Mb [expr ($i*10)]ms DropTail
	$ns duplex-link $r2 $dst($i) 100Mb [expr ($i*10)]ms DropTail
}

$ns duplex-link $r1 $r2 56k 10ms $par1

#設定r1到r2之間的Queue Size為50個封包大小
$ns queue-limit $r1 $r2 50

#把佇列長度記錄下來
set q_ [[$ns link $r1 $r2] queue]
set queuechan [open q-$par1-$par2.tr w]
$q_ trace curq_
$q_ attach $queuechan

# for {set i 0} {$i < $par2} {incr i} {
# 	set tcp($i) [$ns create-connection TCP/Reno $src($i) TCPSink $dst($i) 0]
# 	$tcp($i) set fid_ $i
# }

for {set i 0} {$i < $par2} {incr i} {
  set udp($i) [new Agent/UDP]
  $ns attach-agent $src($i) $udp($i)
  set null($i) [new Agent/Null]
  $ns attach-agent $dst($i) $null($i)
  $ns connect $udp($i) $null($i)
  $udp($i) set fid_ 2
  
  set cbr($i) [new Application/Traffic/CBR]
  $cbr($i) attach-agent $udp($i)
  $cbr($i) set type_ CBR
  $cbr($i) set packet_size_ 1000
  $cbr($i) set rate_ 1mb
  $cbr($i) set random_ false
}

#隨機在0到1秒之間決定資料流開始傳送時間
set rng [new RNG]
$rng seed 1

set RVstart [new RandomVariable/Uniform]
$RVstart set min_ 0
$RVstart set max_ 1
$RVstart use-rng $rng

#決定開始傳送時間
for {set i 0} { $i < $par2 } { incr i } {
	set startT($i) [expr [$RVstart value]]
	#puts "startT($i) $startT($i) sec"
}

# 在指定時間,開始傳送資料
# for {set i 0} {$i < $par2} {incr i} {
# 	set ftp($i) [$tcp($i) attach-app FTP]
# 	$ns at $startT($i) "$ftp($i) start"
# }

for {set i 0} {$i < $par2} {incr i} {
	$ns at $startT($i) "$cbr($i) start"
}

#在第50秒時去呼叫finish來結束模擬
$ns at 50.0 "finish"

#執行模擬
$ns run

