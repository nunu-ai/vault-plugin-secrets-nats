package main

import (
	nats "github.com/edgefarm/vault-plugin-secrets-nats"
	"github.com/hashicorp/vault/sdk/plugin"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func main() {
	zerolog.TimeFieldFormat = zerolog.TimeFormatUnix

	err := plugin.Serve(&plugin.ServeOpts{
		BackendFactoryFunc: nats.Factory,
	})
	if err != nil {
		log.Error().Err(err).Msg("plugin shutting down")
	}
}
