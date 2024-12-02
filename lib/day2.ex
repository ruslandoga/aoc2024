defmodule Day2 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/2
  """

  def input do
    File.stream!("priv/day2.txt")
  end

  def example_input do
    String.split(
      """
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
      """,
      "\n",
      trim: true
    )
  end

  defp process_input(input) do
    Enum.map(input, fn line -> line |> String.split() |> Enum.map(&String.to_integer/1) end)
  end

  @doc """
  Solutions:

      iex> part1(example_input())
      2

      iex> part1(input())
      390

  """
  def part1(input) do
    input
    |> process_input()
    |> Enum.filter(&safe_report?/1)
    |> Enum.count()
  end

  defp safe_report?([a, b | _rest] = report) do
    cond do
      a < b -> safe_report?(report, :inc)
      a > b -> safe_report?(report, :dec)
      a == b -> false
    end
  end

  defp safe_report?([]) do
    raise ArgumentError, "Empty report"
  end

  defp safe_report?([a, b | rest], dir) do
    cond do
      dir == :inc and a < b and b - a <= 3 -> safe_report?([b | rest], dir)
      dir == :dec and a > b and a - b <= 3 -> safe_report?([b | rest], dir)
      true -> false
    end
  end

  defp safe_report?([_], _dir), do: true

  @doc """
  Solutions:

      iex> part2(example_input())
      4

      iex> part2(input())
      439

  """
  def part2(input) do
    input
    |> process_input()
    |> Enum.filter(&dumped_safe_report?/1)
    |> Enum.count()
  end

  defp dumped_safe_report?([a, b | rest]) do
    cond do
      a < b and b - a <= 3 ->
        dumped_safe_report?([b | rest], a, :inc) or safe_report?([a | rest]) or
          safe_report?([b | rest])

      a > b and a - b <= 3 ->
        dumped_safe_report?([b | rest], a, :dec) or safe_report?([a | rest]) or
          safe_report?([b | rest])

      true ->
        safe_report?([a | rest]) or safe_report?([b | rest])
    end
  end

  defp dumped_safe_report?([a, b | rest], prev, dir) do
    cond do
      dir == :inc and a < b and b - a <= 3 ->
        dumped_safe_report?([b | rest], a, dir)

      dir == :dec and a > b and a - b <= 3 ->
        dumped_safe_report?([b | rest], a, dir)

      true ->
        safe_report?([a | rest], dir) or safe_report?([prev, b | rest], dir)
    end
  end

  defp dumped_safe_report?([_], _prev, _dir), do: true
end
