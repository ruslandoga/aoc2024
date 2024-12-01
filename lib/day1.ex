defmodule Day1 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/1
  """

  def input do
    File.stream!("priv/day1.txt")
  end

  def example_input do
    String.split(
      """
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
      """,
      "\n",
      trim: true
    )
  end

  defp process_input(input) do
    input
    |> Enum.map(fn line ->
      [l, r] = String.split(line)
      {String.to_integer(l), String.to_integer(r)}
    end)
  end

  @doc """
  Solutions:

      iex> part1(example_input())
      11

      iex> part1(input())
      2285373

  """
  def part1(input \\ input()) do
    {l, r} =
      input
      |> process_input()
      |> Enum.unzip()

    l = Enum.sort(l)
    r = Enum.sort(r)

    Enum.zip(l, r)
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
  end

  @doc """
  Solutions:

      iex> part2(example_input())
      31

      iex> part2(input())
      21142653

  """
  def part2(input) do
    {l, r} =
      input
      |> process_input()
      |> Enum.unzip()

    r_lookup =
      Enum.reduce(r, %{}, fn x, acc ->
        Map.update(acc, x, 1, &(&1 + 1))
      end)

    Enum.reduce(l, 0, fn x, score ->
      count = Map.get(r_lookup, x, 0)
      score + x * count
    end)
  end
end
