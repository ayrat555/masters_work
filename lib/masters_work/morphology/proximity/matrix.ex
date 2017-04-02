defmodule MastersWork.Morphology.Proximity.Matrix do
  alias MastersWork.Morphology.Proximity.Distance

  def distance_matrix(data, _columns, _legend, :attr) do
    data =
      data
      |> Enum.map(fn(attr) ->
        attr
        |> Enum.map(fn(el) ->
          case el do
            "10" -> "a"
            "11" -> "b"
            "12" -> "c"
            "13" -> "d"
            "14" -> "e"
            "15" -> "f"
            "16" -> "g"
            "17" -> "h"
            "18" -> "i"
            "19" -> "j"
            "20" -> "k"
              _  -> el
          end
        end)
      end)

    data
    |> Enum.with_index
    |> Enum.map(fn({attr1, ind}) ->
      IO.inspect ind

      data
      |> Enum.map(fn(attr2) ->
        Distance.distance(attr1, attr2, :attr)
      end)
    end)
    |> normalize_matrix
  end

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
