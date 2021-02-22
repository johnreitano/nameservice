PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=NameService \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=nameserviced \
	-X github.com/cosmos/cosmos-sdk/version.ClientName=nameservicecli \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) 

BUILD_FLAGS := -ldflags '$(ldflags)'

all: install

install: go.sum
		@echo "--> Installing nameserviced & nameservicecli"
		@go install -mod=readonly $(BUILD_FLAGS) ./cmd/nameserviced
		@go install -mod=readonly $(BUILD_FLAGS) ./cmd/nameservicecli

go.sum: go.mod
		@echo "--> Ensure dependencies have not been modified"
		GO111MODULE=on go mod verify

test:
	@go test -mod=readonly $(PACKAGES)

init:
	rm -rf ~/.nameservicecli ~/.nameserviced
	nameservicecli keys add my_validator --keyring-backend test
	nameservicecli keys add alice --keyring-backend test
	nameservicecli keys list --keyring-backend test
	nameserviced init testing --chain-id testhub
	nameserviced add-genesis-account my_validator 10000000000stake,1000nametoken --keyring-backend test
	nameserviced add-genesis-account alice 10000000000stake,1000nametoken --keyring-backend test
	nameserviced gentx --name my_validator --amount 100000000stake --keyring-backend test
	nameserviced collect-gentxs
	nameserviced validate-genesis
	# MY_VALIDATOR_ADDRESS=$(nameservicecli keys show my_validator -a --keyring-backend test)

start:
	nameserviced start 

transact:
	nameservicecli tx nameservice buy-name kwan.com 2nametoken --from my_validator --keyring-backend test --chain-id testhub
	nameservicecli tx nameservice set-name 5.5.5.5 foo.com --from my_validator --keyring-backend test --chain-id testhub
