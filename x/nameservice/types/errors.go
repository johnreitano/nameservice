package types

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var (
	// ErrNameDoesNotExist indicates that name could not be found in store
	ErrNameDoesNotExist = sdkerrors.Register(ModuleName, 1, "name does not exist")
)
