package main

import (
	"errors"
	"fmt"
	"github.com/briandowns/spinner"
	fzf "github.com/ktr0731/go-fuzzyfinder"
	"github.com/mkanenobu/toolbox/wait-command/lib/hof"
	"github.com/mkanenobu/toolbox/wait-command/lib/process"
	"log"
	"os"
	"time"
)

func main() {
	s := spinner.New(spinner.CharSets[9], 100*time.Millisecond)

	s.Start()
	psCh := make(chan []*process.Process, 1)
	go func() {
		processes, err := process.ListProcesses()
		if err != nil {
			log.Fatal(err)
		}
		psCh <- processes
	}()

	ps := <-psCh
	s.Stop()

	ps = hof.Collect(ps, func(p *process.Process) bool {
		return p != nil && p.Name != "" && p.CommandLine != ""
	})

	selectedIdx, err := fzf.Find(ps,
		func(i int) string {
			return fmt.Sprintf("%d %s", ps[i].Pid, ps[i].CommandLine)
		},
	)
	if errors.Is(err, fzf.ErrAbort) {
		os.Exit(1)
	}
	if err != nil {
		log.Fatal(err)
	}

	pid := ps[selectedIdx].Pid

	s.Start()
	stCh := make(chan *os.ProcessState, 1)
	go func() {
		st, err := process.WaitProcess(int(pid))
		s.Stop()
		if err != nil {
			log.Fatal(err)
		}
		stCh <- st
	}()
	<-stCh

	fmt.Printf("Process %d has been finished, took %d seconds\n", pid, (time.Now().Unix() - ps[selectedIdx].CreateTime.Unix()))
}
