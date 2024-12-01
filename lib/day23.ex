defmodule Day23 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/23
  """

  def input do
    File.stream!("priv/day23.txt")
  end

  def example_input do
    String.split(
      """
      """,
      "\n",
      trim: true
    )
  end

  defp process_input(input) do
    Enum.map(input, &Function.identity/1)
  end

  @doc """
  Solutions:

      iex> part1(example_input())
      []

      iex> part1(input())
      []

  """
  def part1(input \\ input()) do
    input
    |> process_input()
  end

  @doc """
  Solutions:

      iex> part2(example_input())
      []

      iex> part2(input())
      []

  """
  def part2(input) do
    input
    |> process_input()
  end
end
