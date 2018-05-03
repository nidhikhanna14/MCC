set val(chan)        Channel/WirelessChannel        ;#channel type
set val(prop)        Propagation/TwoRayGround   
set val(netif)        Phy/WirelessPhy            ;#network interface t
set val(mac)        Mac/802_11            ;#MAC type
set val(ifq)        Queue/DropTail/PriQueue        ;#interface queue type
set val(ll)        LL                ;#link layer type
set val(ant)        Antenna/OmniAntenna        ;#antena model
set val(ifqlen)    100                ;#max packet in ifq
set val(mn)        4
set val(rp)     AODV
set val(stop)    110       

set ns [new Simulator]
set nf1 [open simple.tr w]
$ns trace-all $nf1

set nf [open simple.nam w]
$ns namtrace-all $nf
$ns namtrace-all-wireless $nf 500 500

set topo [new Topography]
$topo load_flatgrid 500 500
create-god $val(mn)

set chan [new $val(chan)]
$ns node-config -adhocRouting $val(rp)\
-llType $val(ll)\
-macType $val(mac)\
-propType $val(prop)\
-ifqType $val(ifq)\
-ifqLen $val(ifqlen)\
-antType $val(ant)\
-phyType $val(netif)\
-channel $chan\
-topoInstance $topo\
-agentTrace ON\
-routerTrace OFF\
-macTrace ON\
-movementTrace ON\

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$n0 set X_ 120.0
$n0 set Y_ 200.0
$n0 set Z_ 0.0

$n1 set X_ 150.0
$n1 set Y_ 280.0
$n1 set Z_ 0.0

$n2 set X_ 350.0
$n2 set Y_ 180.0
$n2 set Z_ 0.0

$n3 set X_ 350.0
$n3 set Y_ 250.0
$n3 set Z_ 0.0

$ns at 7.0 "$n0 setdest 35.0 45.0 3.0"
$ns at 5.0 "$n2 setdest 45.0 35.0 3.0"
$ns at 10.0 "$n1 setdest 105.0 50.0 3.0"
$ns at 11.0 "$n3 setdest 300.0 60.0 3.0"

set udp0 [new Agent/UDP]
set null0 [new Agent/Null]

$ns attach-agent $n0 $udp0
$ns attach-agent $n3 $null0

$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set rate_ 600kb
$cbr0 set interval_ 0.05
$cbr0 set random_ 1
$cbr0 attach-agent $udp0

$ns at 2.0 "$cbr0 start"

$ns initial_node_pos $n0 30
$ns initial_node_pos $n1 30
$ns initial_node_pos $n2 30
$ns initial_node_pos $n3 30

$ns at $val(stop) "stop"

proc stop {} {
global ns nf nf1
$ns flush-trace
close $nf
close $nf1
exec nam simple.nam &
exit 
}
puts "Starting Simulation..."
$ns run

