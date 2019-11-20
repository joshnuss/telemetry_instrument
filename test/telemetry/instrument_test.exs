defmodule Telemetry.InstrumentTest do
  use ExUnit.Case
  doctest Telemetry.Instrument
  import Telemetry.Instrument

  @events [
    [:spaceship, :lasers],
    [:spaceship, :lasers, :fire]
  ]

  setup do
    :telemetry.attach_many(__MODULE__, @events, fn event, measurement, _metadata, nil ->
      send(self(), {event, measurement})
    end, nil)

    on_exit fn ->
      :telemetry.detach(__MODULE__)
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

  test "measure" do
    fun = fn ->
      Process.sleep(100)
      42
    end

    assert measure("spaceship.lasers.fire", fun) == 42
    assert_received {[:spaceship, :lasers, :fire], %{time: _, tags: []}}

    assert measure("spaceship.lasers.fire", fun, tags: ["great-success"]) == 42
    assert_received {[:spaceship, :lasers, :fire], %{time: _, tags: ["great-success"]}}
  end
end
