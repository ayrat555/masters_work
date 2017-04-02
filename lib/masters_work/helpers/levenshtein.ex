defmodule MastersWork.Helpers.Levenshtein do
  def distance(a, b), do: distance(a, b, HashDict.new) |> elem(0)
  def distance(a, [] = b, cache), do: store_result({a, b}, length(a), cache)
  def distance([] = a, b, cache), do: store_result({a, b}, length(b), cache)
  def distance([x | rest1], [x | rest2], cache) do
    distance(rest1, rest2, cache)
  end
  def distance([_ | rest1] = a, [_ | rest2] = b, cache) do
    case Dict.has_key?(cache, {a, b}) do
      true -> {Dict.get(cache, {a, b}), cache}
      false ->
        {l1, c1} = distance(a, rest2, cache)
        {l2, c2} = distance(rest1, b, c1)
        {l3, c3} = distance(rest1, rest2, c2)

        min = :lists.min([l1, l2, l3]) + 1
        store_result({a, b}, min, c3)
    end
  end

  defp store_result(key, result, cache) do
    {result, Dict.put(cache, key, result)}
  end
end
