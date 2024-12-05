defmodule Day5 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/5
  """

  def input do
    File.read!("priv/day5.txt")
  end

  def example_input do
    """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """
  end

  def process_input(input) do
    [rules, pages] = String.split(input, "\n\n")

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [l, r] = String.split(line, "|")
        {String.to_integer(l), String.to_integer(r)}
      end)

    pages =
      pages
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)

    {rules, pages}
  end

  @doc """
  Solutions:

      iex> part1(example_input())
      143

      iex> part1(input())
      7074

  """
  def part1(input \\ example_input()) do
    {rules, pages} = process_input(input)

    pages
    |> Enum.filter(fn page ->
      page ==
        Enum.sort_by(page, &Function.identity/1, fn l, r ->
          Enum.any?(rules, fn {rl, rr} -> rl == l and rr == r end)
        end)
    end)
    |> Enum.map(fn page -> Enum.at(page, div(length(page), 2)) end)
    |> Enum.sum()
  end

  @doc """
  Solutions:

      iex> part2(example_input())
      123

      iex> part2(input())
      4828

  """
  def part2(input) do
    {rules, pages} = process_input(input)

    pages
    |> Enum.reject(fn page ->
      page ==
        Enum.sort_by(page, &Function.identity/1, fn l, r ->
          Enum.any?(rules, fn {rl, rr} -> rl == l and rr == r end)
        end)
    end)
    |> Enum.map(fn page ->
      Enum.sort_by(page, &Function.identity/1, fn l, r ->
        Enum.any?(rules, fn {rl, rr} -> rl == l and rr == r end)
      end)
    end)
    |> Enum.map(fn page -> Enum.at(page, div(length(page), 2)) end)
    |> Enum.sum()
  end
end
