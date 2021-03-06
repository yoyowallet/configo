package sources

import (
	"io/ioutil"

	"github.com/yoyowallet/configo/parsers"
)

type FileSource struct {
	Path   string `json:"path"`
	Format string `json:"format"`
}

func (fileSource *FileSource) Get() (map[string]interface{}, error) {

	content, err := ioutil.ReadFile(fileSource.Path)

	if err != nil {
		return nil, err
	}

	result := make(map[string]interface{})
	parsers.MustGetParser(fileSource.Format).Parse(content, result)

	return result, nil
}
