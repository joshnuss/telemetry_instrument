defmodule Telemetry.InstrumentTest do
  use ExUnit.Case
  doctest Telemetry.Instrument
  import Telemetry.Instrument

  setup do
    :telemetry.attach(:test, [:spaceship, :lasers], fn event, measurement, _metadata, nil ->
      send(self(), {event, measurement})
    end, nil)

    on_exit fn ->
      :telemetry.detach(:test)
    end
  end

  test "increment" do
    assert increment("spaceship.lasers") == :ok
    assert_received {[:spaceship, :lasers], %{increment: 1, tags: []}}

    assert increment(["spaceship", "lasers"]) == :ok
    assert_received {[:spaceship, :lasers], %{increment: 1, tags: []}}

    assert increment("spaceship.lasers", by: 10) == :ok
    assert_received {[:spaceship, :lasers], %{increment: 10, tags: []}}

    assert increment("spaceship.lasers", tags: ["available", "ready"]) == :ok
    assert_received {[:spaceship, :lasers], %{increment: 1, tags: ["available", "ready"]}}
  end

  test "decrement" do
    assert decrement("spaceship.lasers") == :ok
    assert_received {[:spaceship, :lasers], %{decrement: 1, tags: []}}

    assert decrement(["spaceship", "lasers"]) == :ok
    assert_received {[:spaceship, :lasers], %{decrement: 1, tags: []}}

    assert decrement("spaceship.lasers", by: 10) == :ok
    assert_received {[:spaceship, :lasers], %{decrement: 10, tags: []}}

    assert decrement("spaceship.lasers", tags: ["available", "ready"]) == :ok
    assert_received {[:spaceship, :lasers], %{decrement: 1, tags: ["available", "ready"]}}
  end
end
