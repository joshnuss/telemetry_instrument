# Telemetry.Instrument

Convenience functions for Elixir's [telemetry](https://github.com/beam-telemetry/telemetry).
This is wrapper on top of `:telemery.execute`.

## Increment

Increment a counter:

```elixir
increment("spaceship.engines", by: 20, tags: ["check-engine-light:enabled"])

```

## Decrement

Decrement a counter:

```elixir
decrement("spaceship.engines", by: 2, tags: ["check-engine-light:disabled"])

```

## Measure

Measure how long a function takes:

```elixir
defmodule Lasers do
  def fire do
    Process.sleep(100)
    :pew_pew_pew
  end
end

measure("spaceship.lasers.fire", &Lasers.fire/0, tags: ["great-success"])

```

##

## Installation

```elixir
def deps do
  [
    {:telemetry_instrument, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/telemetry_instrument](https://hexdocs.pm/telemetry_instrument).
