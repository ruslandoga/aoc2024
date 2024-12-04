defmodule Day4 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/4
  """

  def input do
    File.stream!("priv/day4.txt")
  end

  def example_input do
    String.split(
      """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """,
      "\n",
      trim: true
    )
  end

  defp process_input(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end

  @doc """
  Solutions:

      iex> part1(example_input())
      18

      iex> part1(input())
      2545

  """
  def part1(input \\ example_input()) do
    map = process_input(input)
    positions = Map.keys(map)

    Enum.reduce(positions, 0, fn {x, y}, count ->
      matches =
        Enum.count(
          [
            xmas_or_samx?(map, [{x, y}, {x + 1, y}, {x + 2, y}, {x + 3, y}]),
            xmas_or_samx?(map, [{x, y}, {x, y + 1}, {x, y + 2}, {x, y + 3}]),
            xmas_or_samx?(map, [{x, y}, {x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}]),
            xmas_or_samx?(map, [{x, y}, {x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}])
          ],
          &Function.identity/1
        )

      matches + count
    end)
  end

  defp xmas_or_samx?(map, [x, m, a, s]) do
    xmas? =
      Map.get(map, x) == "X" and
        Map.get(map, m) == "M" and
        Map.get(map, a) == "A" and
        Map.get(map, s) == "S"

    smax? =
      Map.get(map, x) == "S" and
        Map.get(map, m) == "A" and
        Map.get(map, a) == "M" and
        Map.get(map, s) == "X"

    xmas? or smax?
  end

  @doc """
  Solutions:

      iex> part2(example_input())
      9

      iex> part2(input())
      1886

  """
  def part2(input) do
    map = process_input(input)
    positions = Map.keys(map)

    Enum.reduce(positions, 0, fn {x, y}, count ->
      match? =
        mas_or_sam?(map, [{x - 1, y - 1}, {x, y}, {x + 1, y + 1}]) and
          mas_or_sam?(map, [{x - 1, y + 1}, {x, y}, {x + 1, y - 1}])

      if match?, do: count + 1, else: count
    end)
  end

  defp mas_or_sam?(map, [m, a, s]) do
    xmas? =
      Map.get(map, m) == "M" and
        Map.get(map, a) == "A" and
        Map.get(map, s) == "S"

    smax? =
      Map.get(map, m) == "S" and
        Map.get(map, a) == "A" and
        Map.get(map, s) == "M"

    xmas? or smax?
  end
end
