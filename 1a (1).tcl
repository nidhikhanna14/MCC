set ns [new Simulator]

set f [open "prac1.tr" w]
$ns trace-all $f

set f1 [open "prac1.nam" w]
$ns namtrace-all $f1

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 50Mb 2ms DropTail
$ns duplex-link $n1 $n5 50Mb 2ms DropTail
$ns duplex-link $n5 $n4 50Mb 2ms DropTail
$ns duplex-link $n4 $n3 100Mb 2ms DropTail
$ns duplex-link $n3 $n2 100Mb 2ms DropTail
$ns duplex-link $n0 $n2 100Mb 2ms DropTail
$ns duplex-link $n1 $n3 100Mb 2ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n5 orient right
$ns duplex-link-op $n5 $n4 orient right-down
$ns duplex-link-op $n4 $n3 orient left-down
$ns duplex-link-op $n3 $n1 orient left-up
$ns duplex-link-op $n3 $n2 orient left
$ns duplex-link-op $n0 $n2 orient right-down

set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
set tcpsink [new Agent/TCPSink]

$ns attach-agent $n0 $tcp0
$ns attach-agent $n3 $tcpsink

$ns connect $tcp0 $tcpsink

set ftp [new Application/FTP]
$ftp attach-agent $tcp0

proc finish {} {
global ns f f1
$ns flush-trace
close $f
close $f1
exec nam prac1.nam &
exit
}

$ns at 0.5 "$ftp start"
$ns at 10 "$ftp start"
$ns at 10.1 "finish"

$ns run




