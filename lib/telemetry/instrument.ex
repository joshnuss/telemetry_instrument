defmodule Telemetry.Instrument do
  @moduledoc """
  Convenience functions for creating [telemetry](https://github.com/beam-telemetry/telemetry) events.
  """

  @type event_name :: [atom()] | String.t()
  @type tags :: [String.t()]

  @doc """
  Increment a value.

  ## Examples

      iex> Telemetry.Instrument.increment("spaceship.engines.active")
      :ok
      iex> Telemetry.Instrument.increment("spaceship.engines.active", by: 10)
      :ok
      iex> Telemetry.Instrument.increment("spaceship.engines.active", tags: ["ready", "available"])
      :ok

  """
  @spec increment(event_name, by: integer(), tags: tags) :: :ok
  def increment(event, opts \\ []) do
    by = Keyword.get(opts, :by, 1)
    tags = Keyword.get(opts, :tags, [])

    publish(event, %{increment: by, tags: tags})
  end

  @doc """
  Decrement a value.

  ## Examples

      iex> Telemetry.Instrument.decrement("spaceship.engines.active")
      :ok
      iex> Telemetry.Instrument.decrement("spaceship.engines.active", by: 10)
      :ok
      iex> Telemetry.Instrument.decrement("spaceship.engines.active", tags: ["ready", "available"])
      :ok

  """
  @spec decrement(event_name, by: integer(), tags: tags) :: :ok
  def decrement(event, opts \\ []) do
    by = Keyword.get(opts, :by, 1)
    tags = Keyword.get(opts, :tags, [])

    publish(event, %{decrement: by, tags: tags})
  end

  @doc """
  Measures duration of function call.

  ## Examples

      iex> Telemetry.Instrument.measure("spaceship.lasers.fire", fn -> :pew_pew_pew end)
      :pew_pew_pew
      iex> Telemetry.Instrument.measure("spaceship.lasers.fire", fn -> :pew_pew_pew end, tags: ["ready", "available"])
      :pew_pew_pew

  """
  @spec measure(event_name, fun(), tags: tags) :: any
  def measure(event, fun, opts \\ []) do
    tags = Keyword.get(opts, :tags, [])

    {time, value} = :timer.tc(fun)

    :ok = publish(event, %{duration: time, tags: tags})

    value
  end

  defp to_name(list) when is_list(list) do
    Enum.map(list, &to_atom/1)
  end

  defp to_name(name) when is_binary(name) do
    name
    |> String.split(".")
    |> Enum.map(&String.to_atom/1)
  end

  defp to_atom(value) when is_atom(value), do: value
  defp to_atom(value), do: String.to_atom(value)

  defp publish(event, payload) do
    event
    |> to_name()
    |> :telemetry.execute(payload)
  end
end
