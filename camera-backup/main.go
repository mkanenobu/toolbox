package main

import (
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"os/signal"
	p "path"
	"sort"
	"strings"
	"sync"
	"syscall"
)

const COPY_TO_DIR = "~/Pictures"
const COPY_WORKERS = 4

func getCopyToDir() string {
	h, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}
	return p.Join(h, "Pictures")
}

var COPY_FROM_VOLUMES = []string{"/Volumes/SIGMA fp/DCIM/100SIGMA"}

// Backup not backed up files
func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGHUP, syscall.SIGQUIT, syscall.SIGTERM)
	defer stop()
	go func() {
		<-ctx.Done()
		stop()
	}()

	// Check copy target exists and list files
	backupTargetFilePaths := make([]string, 0)
	for _, dir := range COPY_FROM_VOLUMES {
		if isDir(dir) {
			files, err := listFiles(dir)
			if err != nil {
				panic(err)
			}

			backupTargetFilePaths = append(backupTargetFilePaths, files...)
		}
	}

	if len(backupTargetFilePaths) == 0 {
		fmt.Println("No copy target files or volumes")
	}

	copyToDir := getCopyToDir()
	// // List backuped files
	existsFiles, err := listFiles(copyToDir)
	if err != nil {
		panic(err)
	}

	notBackupedPaths := fileNameDiff(backupTargetFilePaths, existsFiles)
	sort.Slice(notBackupedPaths, func(i, j int) bool { return notBackupedPaths[i] < notBackupedPaths[j] })

	if len(notBackupedPaths) == 0 {
		fmt.Println("No files to copy")
		return
	}

	err = copyFiles(ctx, notBackupedPaths, copyToDir)
	if err != nil {
		if errors.Is(err, context.Canceled) {
			fmt.Println("Canceled")
			os.Exit(130)
		}
		panic(err)
	}
}

type copyJob struct {
	srcPath string
	dstPath string
}

type copyResult struct {
	srcPath string
	err     error
}

func copyFiles(ctx context.Context, srcPaths []string, copyToDir string) error {
	jobs := make(chan copyJob)
	results := make(chan copyResult)

	workerCount := min(COPY_WORKERS, len(srcPaths))
	var wg sync.WaitGroup
	for range workerCount {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for {
				select {
				case <-ctx.Done():
					return
				case job, ok := <-jobs:
					if !ok {
						return
					}
					err := tryCopy(ctx, job.srcPath, job.dstPath)
					results <- copyResult{srcPath: job.srcPath, err: err}
				}
			}
		}()
	}

	go func() {
		for _, srcPath := range srcPaths {
			job := copyJob{
				srcPath: srcPath,
				dstPath: p.Join(copyToDir, p.Base(srcPath)),
			}
			select {
			case <-ctx.Done():
				close(jobs)
				wg.Wait()
				close(results)
				return
			case jobs <- job:
			}
		}
		close(jobs)
		wg.Wait()
		close(results)
	}()

	total := len(srcPaths)
	fmt.Printf("Copying %d files...\n", total)

	doneCount := 0
	errs := make([]error, 0)
	for result := range results {
		doneCount++
		if result.err != nil {
			errs = append(errs, fmt.Errorf("copy %s failed: %w", result.srcPath, result.err))
		}
		fmt.Printf("\rCopied %d/%d", doneCount, total)
	}
	fmt.Println()

	return errors.Join(errs...)
}

func isDir(path string) bool {
	info, err := os.Stat(path)
	if err != nil {
		return false
	}

	return info.IsDir()
}

func listFiles(path string) ([]string, error) {
	existsFiles, err := os.ReadDir(path)
	if err != nil {
		return nil, err
	}

	files := make([]string, 0, len(existsFiles))
	for _, file := range existsFiles {
		if !file.IsDir() && !strings.HasPrefix(file.Name(), ".") {
			files = append(files, p.Join(path, file.Name()))
		}
	}

	return files, nil
}

func fileNameDiff(targetFiles, existsFiles []string) []string {
	existsFilesMap := make(map[string]struct{}, len(existsFiles))
	for _, file := range existsFiles {
		fName := p.Base(file)
		existsFilesMap[fName] = struct{}{}
	}

	notBackuped := make([]string, 0)
	for _, file := range targetFiles {
		fName := p.Base(file)
		if _, exists := existsFilesMap[fName]; !exists {
			notBackuped = append(notBackuped, file)
		}
	}

	return notBackuped
}

func tryCopy(ctx context.Context, srcName, dstName string) error {
	if err := ctx.Err(); err != nil {
		return err
	}

	err := (func() error {
		s, err := os.Stat(dstName)
		if err != nil {
			if os.IsNotExist(err) {
				return nil
			}
			return err
		}
		if s != nil {
			return errors.New("file already exists")
		}
		return nil
	})()
	if err != nil {
		return err
	}

	tmpName := fmt.Sprintf("%s.%d.tmp", dstName, os.Getpid())
	completed := false
	defer func() {
		if !completed {
			_ = os.Remove(tmpName)
		}
	}()

	src, err := os.Open(srcName)
	if err != nil {
		return err
	}
	defer src.Close()

	dst, err := os.Create(tmpName)
	if err != nil {
		return err
	}
	defer dst.Close()

	if err := copyWithContext(ctx, dst, src); err != nil {
		return err
	}

	if err := dst.Close(); err != nil {
		return err
	}

	if err := os.Rename(tmpName, dstName); err != nil {
		return err
	}
	completed = true

	return nil
}

func copyWithContext(ctx context.Context, dst io.Writer, src io.Reader) error {
	buf := make([]byte, 1024*1024)
	for {
		if err := ctx.Err(); err != nil {
			return err
		}

		nr, er := src.Read(buf)
		if nr > 0 {
			if err := ctx.Err(); err != nil {
				return err
			}

			nw, ew := dst.Write(buf[:nr])
			if nw < 0 || nr < nw {
				nw = 0
				if ew == nil {
					ew = errors.New("invalid write result")
				}
			}
			if ew != nil {
				return ew
			}
			if nr != nw {
				return io.ErrShortWrite
			}
		}
		if er != nil {
			if errors.Is(er, io.EOF) {
				return nil
			}
			return er
		}
	}
}
