defmodule MastersWork.Phonetics.VectorParams do
  def params(community_values1, community_values2) do
    result = %{a: 0, b: 0, c: 0, d: 0, f: 0}
    _params(community_values1, community_values2, result)
  end

  defp _params([head1 | []], [head2 | []], %{a: a, d: d} = result) when head1 == head2 do
    case head1 do
      0 -> %{result | a: a + 1}
      _ -> %{result | d: d + 1}
    end
  end

  defp _params([head1 | []], [_head2 | []], %{c: c} = result) when head1 == "0" do
    %{result | c: c + 1}
  end

  defp _params([_head1 | []], [head2 | []], %{b: b} = result) when head2 == "0" do
    %{result | b: b + 1}
  end

  defp _params([_head1 | []], [_head2 | []], %{f: f} = result) do
    %{result | f: f + 1}
  end

  defp _params([head1 | tail1], [head2 | tail2], %{a: a, d: d} = result) when head1 == head2 do
    result = case head1 do
        0 -> %{result | a: a + 1}
        _ -> %{result | d: d + 1}
      end
    _params(tail1, tail2, result)
  end

  defp _params([head1 | tail1], [_head2 | tail2], %{c: c} = result) when head1 == "0" do
    result = %{result | c: c + 1}

    _params(tail1, tail2, result)
  end

  defp _params([_head1 | tail1], [head2 | tail2], %{b: b} = result) when head2 == "0" do
    result = %{result | b: b + 1}

    _params(tail1, tail2, result)
  end

  defp _params([_head1 | tail1], [_head2 | tail2], %{f: f} = result) do
    result = %{result | f: f + 1}

    _params(tail1, tail2, result)
  end
end
