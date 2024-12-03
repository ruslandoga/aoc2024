defmodule Day3 do
  @moduledoc """
  Solutions for https://adventofcode.com/2024/day/3
  """

  def input do
    File.read!("priv/day3.txt")
  end

  def example_input do
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  end

  def example_input_2 do
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  end

  defp process_input(input) do
    parse_instructions(input, _acc = [])
  end

  defp parse_instructions("mul(" <> rest, acc) do
    parse_int_1(rest, 0, acc)
  end

  defp parse_instructions("do()" <> rest, acc) do
    parse_instructions(rest, [:do | acc])
  end

  defp parse_instructions("don't()" <> rest, acc) do
    parse_instructions(rest, [:dont | acc])
  end

  defp parse_instructions(<<_, rest::bytes>>, acc) do
    parse_instructions(rest, acc)
  end

  defp parse_instructions(<<>>, acc) do
    :lists.reverse(acc)
  end

  defp parse_int_1(<<c, rest::bytes>>, inner_acc, outer_acc) when c in ?0..?9 do
    parse_int_1(rest, inner_acc * 10 + c - ?0, outer_acc)
  end

  defp parse_int_1(<<?,, rest::bytes>>, inner_acc, outer_acc) do
    parse_int_2(rest, 0, [inner_acc | outer_acc])
  end

  defp parse_int_1(<<_, rest::bytes>>, _inner_acc, outer_acc) do
    parse_instructions(rest, outer_acc)
  end

  defp parse_int_2(<<c, rest::bytes>>, inner_acc, outer_acc) when c in ?0..?9 do
    parse_int_2(rest, inner_acc * 10 + c - ?0, outer_acc)
  end

  defp parse_int_2(<<?), rest::bytes>>, r, [l | outer_acc]) do
    parse_instructions(rest, [{:mul, l, r} | outer_acc])
  end

  defp parse_int_2(<<_, rest::bytes>>, _inner_acc, [_l | outer_acc]) do
    parse_instructions(rest, outer_acc)
  end

  @doc """
  Solutions:

      iex> part1(example_input())
      161

      iex> part1(input())
      174561379

  """
  def part1(input) do
    input
    |> process_input()
    |> Enum.map(fn
      {:mul, a, b} -> a * b
      _do_or_do_not -> 0
    end)
    |> Enum.sum()
  end

  @doc """
  Solutions:

      iex> part2(example_input_2())
      48

      iex> part2(input())
      106921067

  """
  def part2(input) do
    input
    |> process_input()
    |> do_or_do_not_mul(_multiplier = 1, _acc = 0)
  end

  defp do_or_do_not_mul([{:mul, l, r} | rest], multiplier, acc) do
    do_or_do_not_mul(rest, enabled?, acc + multiplier * l * r)
  end

  defp do_or_do_not_mul([:do | rest], _multiplier, acc) do
    do_or_do_not_mul(rest, 1, acc)
  end

  defp do_or_do_not_mul([:dont | rest], _multiplier, acc) do
    do_or_do_not_mul(rest, 0, acc)
  end

  defp do_or_do_not_mul([], _multiplier, acc) do
    acc
  end
end
