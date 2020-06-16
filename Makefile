.PHONY: server

export MIX_ENV ?= dev
export SECRET_KEY_BASE ?= $(shell mix phx.gen.secret)

server: MIX_ENV=dev
server:
	@source .env_setup && iex --name everlive@127.0.0.1 -S mix phx.server

setup: 
	@source .env_setup && mix ecto.setup
reset:
	@source .env_setup && mix ecto.reset
migrate: 
	@source .env_setup && mix ecto.migrate