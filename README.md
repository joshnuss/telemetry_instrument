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
increment("spaceship.engines", by: 2, tags: ["check-engine-light:disabled"])

```

## Measure

Measure how long a function takes:

```elixir
def fire_lasers, do: :pew_pew_pew

measure("spaceship.lasers.fire", &fire_lasers/0, tags: ["great-success"])

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
