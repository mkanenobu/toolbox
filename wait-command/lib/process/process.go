package process

import (
	"github.com/mkanenobu/toolbox/wait-command/lib/hof"
	proc "github.com/shirou/gopsutil/v4/process"
	"os"
	"time"
)

type Process struct {
	Pid         int32
	Name        string
	CommandLine string
	CreateTime  time.Time
}

func ListProcesses() ([]*Process, error) {
	ps, err := proc.Processes()
	if err != nil {
		return nil, err
	}

	return hof.Map(ps, func(p *proc.Process) *Process {
		// Following fields getter are slow
		name, _ := p.Name()
		commandLine, _ := p.Cmdline()
		createTime, _ := p.CreateTime()
		return &Process{
			Pid:         p.Pid,
			Name:        name,
			CommandLine: commandLine,
			CreateTime:  time.Unix(0, createTime*int64(time.Millisecond)),
		}
	}), nil
}

func WaitProcess(pid int) (*os.ProcessState, error) {
	// Can't find process by pid (maybe os.FindProcess is only for the child processes)
	p, err := os.FindProcess(pid)
	if err != nil {
		return nil, err
	}

	s, err := p.Wait()
	if err != nil {
		return nil, err
	}

	return s, nil
}
