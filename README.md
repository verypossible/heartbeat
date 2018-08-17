# Heartbeat

A tool for generating visual representations of near real time, digital interactions.

## Requirements

    * Elixir
    * Nerves
    * Docker
    * fwup
    * A microSD card (for burning firmware)
    * A Raspberry Pi 3 model B

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. Targets are represented by
a short name like `rpi3_sudo` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=rpi3_sudo` or prefix every command with
    `MIX_TARGET=rpi3_sudo`.
  * Install dependencies with `mix deps.get`
  * Build docker image with `docker build -t compile_image .`
  * Connect to docker image with `docker run -v $(pwd)/output:/opt/firmware/output --rm -it compile_image bash`
    (The -v option will mount a volume through which we will receive build artifacts from the docker container)
  # Inside of the docker image
  * Build firmware image `mix firmware`
  * Copy firmware to mounted volume `cp _build/rpi3_sudo/dev/nerves/images/heartbeat.fw ./output/`
  * Exit docker image with `exit`
  # Back outside of docker image
  * Burn firmware to connected microSD card `fwup ./output/heartbeat.fw`
  * Install microSD card into Pi and boot up.

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
