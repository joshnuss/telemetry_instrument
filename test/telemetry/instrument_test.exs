defmodule Telemetry.InstrumentTest do
  use ExUnit.Case
  doctest Telemetry.Instrument

  test "greets the world" do
    assert Telemetry.Instrument.hello() == :world
  end
end
