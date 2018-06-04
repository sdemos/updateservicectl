.PHONY:	all clean test vendor
export CGO_ENABLED:=0

REPO=github.com/coreos/updateservicectl
ROLLER_URL ?= http://localhost:8000

all: bin/updateservicectl

bin/%:
	go build -o $@ $(REPO)

vendor:
	glide update --strip-vendor
	glide-vc --use-lock-file --no-tests --only-code

clean:
	rm -rf bin

api-gen:
	curl $(ROLLER_URL)/_ah/api/discovery/v1/apis/update/v1/rest > client/update/v1/update-api.json
	google-api-go-generator -api_json_file client/update/v1/update-api.json -api_pkg_base $(REPO)/client -gendir client
