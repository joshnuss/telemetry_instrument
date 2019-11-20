defmodule Telemetry.Instrument do
  @moduledoc """
  Convenience functions for creating [telemetry](https://github.com/beam-telemetry/telemetry) events.
  """

  @type event_name :: [atom()] | String.t

  @doc """
  Increment a value

  ## Examples

      iex> Telemetry.Instrument.increment("spaceship.engines.active")
      :ok
      iex> Telemetry.Instrument.increment("spaceship.engines.active", by: 10)
      :ok

  """
  @spec increment(event_name, [by: integer()]) :: :ok
  def increment(event, opts \\ []) do
    by = Keyword.get(opts, :by, 1)

    event
    |> to_name()
    |> :telemetry.execute(%{increment: by})
  end

  @doc """
  Decrement a value

  ## Examples

      iex> Telemetry.Instrument.decrement("spaceship.engines.active")
      :ok
      iex> Telemetry.Instrument.decrement("spaceship.engines.active", by: 10)
      :ok

  """
  @spec decrement(event_name, [by: integer()]) :: :ok
  def decrement(event, opts \\ []) do
    by = Keyword.get(opts, :by, 1)

    event
    |> to_name()
    |> :telemetry.execute(%{decrement: by})
  end

  defp to_name(name) when is_list(name) do
    Enum.map(name, &String.to_atom/1)
  end

  defp to_name(name) when is_binary(name) do
    name
    |> String.split(".")
    |> Enum.map(&String.to_atom/1)
  end
end
