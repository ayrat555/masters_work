defmodule MastersWork.Morphology.Proximity.Matrix do
  alias MastersWork.Morphology.Proximity.Distance

  def distance_matrix(data, columns, legend, distance_alg) do
    data
    |> Enum.with_index
    |> Enum.map(fn({val1, ind}) ->
      IO.inspect ind
      atr1 = attributes(val1, columns, legend)

      data
      |> Enum.map(fn(val2) ->
        atr2 = attributes(val2, columns, legend)
        dist = Distance.distance(atr1, atr2, distance_alg)
        Enum.sum(dist) / Enum.count(atr2)
      end)
    end)
    |> normalize_matrix
  end

  def attributes(values, columns, legend) do
    values
    |> Enum.with_index
    |> Enum.map(fn({el, ind}) ->
      column = columns |> Enum.at(ind)
      legend |> Enum.find_value(fn({col, val, attributes}) -> if (col == column) && (val == el), do: attributes end)
    end)
    |> Enum.reject(fn(el) -> is_nil(el) end)
  end

  def normalize_matrix(matrix) do
    min =
    matrix
    |> Enum.map(fn(row) ->
      row |> Enum.min
    end)
    |> Enum.min

    max =
    matrix
    |> Enum.map(fn(row) ->
      row |> Enum.max
    end)
    |> Enum.max

    matrix
    |> Enum.map(fn(row) ->
      row
      |> Enum.map(fn(el) ->
        (el - min)/(max - min)
      end)
    end)
  end
end
