package handler

import (
	"fmt"
	"github.com/go-ping/ping"
	"github.com/martinlindhe/notify"
	"time"
)

func OnRecover(rrtThreshold time.Duration) func(packet *ping.Packet) {
	return func(pkt *ping.Packet) {
		if pkt.Rtt >= rrtThreshold {
			notify.Alert(
				"ping-checker",
				"ping-checker",
				fmt.Sprintf("ping rount-trip over %d ms: %d ms", rrtThreshold.Milliseconds(), pkt.Rtt.Milliseconds()),
				"",
			)
		}

		fmt.Printf("%d bytes from %s: icmp_seq=%d time=%v\n",
			pkt.Nbytes, pkt.IPAddr, pkt.Seq, pkt.Rtt)
	}
}

func OnDuplicateRecovery(pkt *ping.Packet) {
	fmt.Printf("%d bytes from %s: icmp_seq=%d time=%v ttl=%v (DUP!)\n",
		pkt.Nbytes, pkt.IPAddr, pkt.Seq, pkt.Rtt, pkt.Ttl)
}

func OnFinish(stats *ping.Statistics) {
	fmt.Printf("\n--- %s ping statistics ---\n", stats.Addr)
	fmt.Printf("%d packets transmitted, %d packets received, %v%% packet loss\n",
		stats.PacketsSent, stats.PacketsRecv, stats.PacketLoss)
	fmt.Printf("round-trip min/avg/max/stddev = %v/%v/%v/%v\n",
		stats.MinRtt, stats.AvgRtt, stats.MaxRtt, stats.StdDevRtt)
}
