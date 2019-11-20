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
    assert_received {[:spaceship, :lasers], %{increment: 1}}

    assert increment(["spaceship", "lasers"]) == :ok
    assert_received {[:spaceship, :lasers], %{increment: 1}}

    assert increment("spaceship.lasers", 10) == :ok
    assert_received {[:spaceship, :lasers], %{increment: 10}}
  end
end
