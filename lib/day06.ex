defmodule Day6 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/6
  """

  def input do
    File.read!("priv/day06.txt")
  end

  def example_input do
    """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """
  end

  def process_input(input) do
    map =
      String.split(input, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc ->
        String.split(line, "", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, acc -> Map.put(acc, {x, y}, char) end)
      end)

    {guard, char} = Enum.find(map, fn {_, v} -> v in ["^", "<", ">", "v"] end)
    {Map.put(map, guard, "."), guard, char}
  end

  @doc """
  Solutions:

      iex> part1(example_input())
      41

      iex> part1(input())
      5212

  """
  def part1(input \\ example_input()) do
    {map, guard, char} = process_input(input)
    visited = walk(char, guard, map, _visited = [guard])

    visited
    |> Enum.uniq()
    |> Enum.count()
  end

  defp walk(direction, position, map, visited) do
    next_position = next_position(direction, position)

    case Map.get(map, next_position) do
      nil -> [position | visited]
      "." -> walk(direction, next_position, map, [position | visited])
      "#" -> walk(turn_right(direction), position, map, visited)
    end
  end

  defp next_position(direction, {x, y}) do
    case direction do
      "^" -> {x, y - 1}
      "<" -> {x - 1, y}
      ">" -> {x + 1, y}
      "v" -> {x, y + 1}
    end
  end

  defp turn_right(direction) do
    case direction do
      "^" -> ">"
      "<" -> "^"
      ">" -> "v"
      "v" -> "<"
    end
  end

  @doc """
  Solutions:

      iex> part2(example_input())
      6

      iex> part2(input())
      1767

  """
  def part2(input \\ example_input()) do
    {map, guard, char} = process_input(input)
    visited = walk(char, guard, map, _visited = [guard])
    uniq_visited = Enum.uniq(visited) -- [guard]

    Enum.reduce(uniq_visited, 0, fn {x, y}, acc ->
      visited_obstructions = MapSet.new()
      looped? = looped?(char, guard, Map.put(map, {x, y}, "#"), visited_obstructions)
      if looped?, do: acc + 1, else: acc
    end)
  end

  defp looped?(direction, position, map, visited_obstructions) do
    next_position = next_position(direction, position)

    case Map.get(map, next_position) do
      nil ->
        false

      "." ->
        looped?(direction, next_position, map, visited_obstructions)

      "#" ->
        if MapSet.member?(visited_obstructions, {direction, position}) do
          true
        else
          visited_obstructions = MapSet.put(visited_obstructions, {direction, position})
          looped?(turn_right(direction), position, map, visited_obstructions)
        end
    end
  end
end
