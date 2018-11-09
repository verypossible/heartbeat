defmodule Heartbeat.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :heartbeat,
      version: "0.1.0",
      elixir: "~> 1.6",
      target: @target,
      archives: [nerves_bootstrap: "~> 1.0"],
      deps_path: "deps/#{@target}",
      build_path: "_build/#{@target}",
      lockfile: "mix.lock.#{@target}",
      start_permanent: Mix.env() == :prod,
      build_embedded: @target != "host",
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Heartbeat.Application, []},
      extra_applications: [:logger, :poison, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.0", runtime: false},
      {:shoehorn, "~> 0.2"},
      {:ring_logger, "~> 0.4"},
      {:slack, "~> 0.15.0"},
      {:rpi_rgb_led_matrex, git: "https://github.com/verypossible/rpi_rgb_led_matrex"}
    ] ++ deps(@target)
  end

  # Specify target specific dependencies
  defp deps("host"), do: []

  defp deps(target) do
    [
      {:nerves_runtime, "~> 0.4"},
      {:nerves_time, "~> 0.2"},
      {:nerves_init_gadget, "~> 0.4"},
      {:nerves_network, "~> 0.3.6"}
    ] ++ system(target)
  end

  defp system("rpi3_sudo"),
    do: [{:rpi3_sudo, git: "https://github.com/verypossible/rpi3_sudo", runtime: false}]

  defp system(target), do: Mix.raise("Unknown MIX_TARGET: #{target}")
end
