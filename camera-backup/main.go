package main

import (
	"errors"
	"fmt"
	"io"
	"os"
	p "path"
	"sort"
	"strings"
)

const COPY_TO_DIR = "~/Pictures"

func getCopyToDir() string {
	h, err := os.UserHomeDir()
	if err != nil {
		panic(err)
	}
	return p.Join(h, "Pictures")
}

var COPY_FROM_VOLUMES = []string{"/Volumes/SIGMA fp/DCIM/100SIGMA"}

/**
Backup not backuped files
*/
func main() {
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

	for _, srcPath := range notBackupedPaths {
		fmt.Printf("%s\n", srcPath)
		err = tryCopy(srcPath, p.Join(copyToDir, p.Base(srcPath)))
		if err != nil {
			_ = fmt.Errorf("copy %s to %s failed: %v", srcPath, copyToDir, err)
		}
	}
	fmt.Printf("%d\n", len(notBackupedPaths))
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

func tryCopy(srcName, dstName string) error {
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

	src, err := os.Open(srcName)
	if err != nil {
		panic(err)
	}
	defer src.Close()

	dst, err := os.Create(dstName)
	if err != nil {
		panic(err)
	}
	defer dst.Close()
	_, err = io.Copy(dst, src)
	return err
}
