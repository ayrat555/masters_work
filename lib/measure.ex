defmodule Measure do
  def proximity_matrix(dataset) do
    dataset |> Enum.map(&proximity_vector(dataset, &1))
  end

  defp proximity_vector(dataset, community_values) do
    dataset |> Enum.map(&proximity_measure(community_values, &1))
  end

  def proximity_measure(community_values1, community_values2) do
    result = %{a: 0, b: 0, c: 0, d: 0, f: 0}
    _proximity_measure(community_values1, community_values2, result)
  end
  
  defp _proximity_measure([head1 | []], [head2 | []], %{a: a, d: d} = result) when head1 == head2 do
    case head1 do
      0 -> %{result | a: a + 1}
      _ -> %{result | d: d + 1}
    end |> calculate_proximity
  end

  defp _proximity_measure([head1 | []], [_head2 | []], %{c: c} = result) when head1 == "0" do
    %{result | c: c + 1} |> calculate_proximity
  end

  defp _proximity_measure([_head1 | []], [head2 | []], %{b: b} = result) when head2 == "0" do
    %{result | b: b + 1} |> calculate_proximity
  end

  defp _proximity_measure([_head1 | []], [_head2 | []], %{f: f} = result) do
    %{result | f: f + 1} |> calculate_proximity
  end

  defp _proximity_measure([head1 | tail1], [head2 | tail2], %{a: a, d: d} = result) when head1 == head2 do
    result = case head1 do
        0 -> %{result | a: a + 1}
        _ -> %{result | d: d + 1}
      end
    _proximity_measure(tail1, tail2, result)
  end

  defp _proximity_measure([head1 | tail1], [_head2 | tail2], %{c: c} = result) when head1 == "0" do
    result = %{result | c: c + 1}

    _proximity_measure(tail1, tail2, result)
  end

  defp _proximity_measure([_head1 | tail1], [head2 | tail2], %{b: b} = result) when head2 == "0" do
    result = %{result | b: b + 1}

    _proximity_measure(tail1, tail2, result)
  end

  defp _proximity_measure([_head1 | tail1], [_head2 | tail2], %{f: f} = result) do
    result = %{result | f: f + 1}

    _proximity_measure(tail1, tail2, result)
  end

  defp calculate_proximity(%{a: a, b: b, c: c, d: d, f: f}) do
    (a + d) / (a + b + c + d + f)
  end
end
