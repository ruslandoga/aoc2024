defmodule Day5 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/5
  """

  def input do
    File.read!("priv/day05.txt")
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

  @doc """
  Solutions:

      iex> solve(example_input())
      {143, 123}

      iex> solve(input())
      {7074, 4828}

  """
  def solve(input \\ example_input()) do
    [rules, pages] = String.split(input, "\n\n")

    pages =
      pages
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)

    Enum.reduce(pages, {0, 0}, fn page, {p1, p2} ->
      sorted =
        Enum.sort_by(page, &Function.identity/1, fn l, r ->
          String.contains?(rules, "#{l}|#{r}")
        end)

      mid = Enum.at(sorted, div(length(sorted), 2))

      if page == sorted do
        {p1 + mid, p2}
      else
        {p1, p2 + mid}
      end
    end)
  end
end
