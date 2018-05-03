set ns [new Simulator]

set f [open "new.tr" w]
$ns trace-all $f

set f1 [open "new.nam" w]
$ns namtrace-all $f1

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n0 $n1 50Mb 2ms DropTail
$ns duplex-link $n1 $n5 50Mb 2ms DropTail
$ns duplex-link $n5 $n4 50Mb 2ms DropTail
$ns duplex-link $n4 $n6 50Mb 2ms DropTail
$ns duplex-link $n4 $n3 50Mb 2ms DropTail
$ns duplex-link $n3 $n1 50Mb 2ms DropTail
$ns duplex-link $n3 $n2 50Mb 2ms DropTail
$ns duplex-link $n2 $n0 50Mb 2ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n5 orient right
$ns duplex-link-op $n5 $n4 orient right-down
$ns duplex-link-op $n4 $n6 orient right
$ns duplex-link-op $n4 $n3 orient left-down
$ns duplex-link-op $n3 $n1 orient left-up
$ns duplex-link-op $n3 $n2 orient left
$ns duplex-link-op $n2 $n0 orient left-up

set udp0 [new Agent/UDP]
$udp0 set class_ 2
set null [new Agent/Null]

$ns attach-agent $n1 $udp0
$ns attach-agent $n6 $null

$ns connect $udp0 $null

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp0
$cbr set packetSize_ 100
$cbr set rate_ 1Mb

proc finish {} {
global ns f f1
$ns flush-trace
close $f
close $f1
exec nam new.nam &
exit
}

$ns at 0.1 "$cbr start"
$ns at 10 "$cbr stop"
$ns at 10.1 "finish"

$ns run






