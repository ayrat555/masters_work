defmodule MastersWork.Helpers.Hamming do
  def distance(strand1, strand2) do
    hamming(strand1, strand2, 0)
  end

  defp hamming([], [], count), do: count
  defp hamming([x|strand1], [x|strand2], count), do: hamming(strand1, strand2, count)
  defp hamming([_|strand1], [_|strand2], count), do: hamming(strand1, strand2, count+1)
  defp hamming([], second, count), do: count + Enum.count(second)
  defp hamming(first, [], count), do: count + Enum.count(first)
end
