# Heartbeat

A tool for generating visual representations of near real time, slack interactions.

## Requirements

    * Elixir
    * Nerves
    * Docker
    * fwup
    * A microSD card (for burning firmware)
    * A Raspberry Pi 3 model B
    * An Adafruit LED Matrix panel e.g. https://www.adafruit.com/product/1484

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. Targets are represented by
a short name like `rpi3_sudo` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * Create a .env file:
    * SLACK_TOKEN="SLACK_TOKEN HERE"
    * MIX_TARGET="rpi3_sudo"
  * Set environment with `source .env`
  * Create an SSH key: `ssh-keygen -t rsa -b 4096 -C "email@example.com"` (Place key in project directory with name: `.ssh/heartbeat_ssh`)
  * Install dependencies with `mix deps.get`
  * Build docker image with `docker build -t compile_image .`
  * Connect to docker image with `docker run -e SLACK_TOKEN=$SLACK_TOKEN -v $(pwd)/output:/opt/firmware/output --rm -it compile_image bash`
    (The -v option will mount a volume through which we will receive build artifacts from the docker container)
  ### Inside of the docker image
  * Build firmware image `mix firmware`
  * Copy firmware to mounted volume `cp _build/rpi3_sudo/dev/nerves/images/heartbeat.fw ./output/`
  * Exit docker image with `exit`
  ### Back outside of docker image
  * Use the upload script to copy firmware to the device via SSH: `./upload.sh IP_ADDRESS output/heartbeat.fw .ssh/heartbeat_ssh`
  * Bonus: Connect to the Pi via SSH: `ssh -i .ssh/heartbeat_ssh IP_ADDRESS`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
