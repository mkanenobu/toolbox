package main

import (
	"flag"
	"fmt"
	"github.com/go-ping/ping"
	"mkanenobu.com/ping-checker/lib/handler"
	"os"
	"os/signal"
	"time"
)

type CommandLineOption struct {
	PingDest string
}

func parseCommandLineOption() CommandLineOption {
	flag.Parse()
	args := flag.Args()

	return CommandLineOption{PingDest: args[0]}
}

func interrupter() chan os.Signal {
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)

	return c
}

func pingClient(option CommandLineOption) *ping.Pinger {
	cli, err := ping.NewPinger(option.PingDest)
	if err != nil {
		panic(err)
	}
	cli.Timeout = time.Second * 10
	return cli
}

func main() {
	op := parseCommandLineOption()
	cli := pingClient(op)

	interrupt := interrupter()
	go func() {
		for _ = range interrupt {
			cli.Stop()
		}
	}()

	cli.OnRecv = handler.OnRecover(time.Millisecond * 1000)
	cli.OnDuplicateRecv = handler.OnDuplicateRecovery
	cli.OnFinish = handler.OnFinish

	fmt.Printf("PING %s (%s):\n", cli.Addr(), cli.IPAddr())
	err := cli.Run()
	if err != nil {
		panic(err)
	}
}
