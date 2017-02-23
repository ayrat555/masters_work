defmodule MastersWork.Phonetics.Base do
  alias MastersWork.Preprocessor
  alias MastersWork.Helpers.Levenshtein

  @input_path "data/input/morphology.csv"
  @input_legend_path "data/input/morphology_legend_revised.csv"

  def execute do
    {communities, column_names, values} = Preprocessor.read(@input_path)
    columns = column_names |> columns
    legend = parse_legend
    distance_matrix(values, columns, legend)
  #  {values, columns, legend}
  end

  def parse_legend do
    lines = File.stream!(@input_legend_path) |> CSV.decode(separator: ?;) |> Enum.to_list
    for [num, value, words] <- lines do
      {col_int, ""} = Integer.parse(num)
      {col_int, value, String.split(words,",")}
    end
  end

  def columns(column_names) do
    for col <- column_names do
      {int, _} = col |> String.replace("Карта", "") |> String.trim |> Integer.parse
      int
    end
  end

  def distance_matrix(data, columns, legend) do
    data
    |> Enum.map(fn(val1) ->
      atr1 = attributes(val1, columns, legend)
      data
      |> Enum.map(fn(val2) ->
        atr2 = attributes(val2, columns, legend)
        distance(atr1, atr2)
      end)
    end)
  end

  def attributes(values, columns, legend) do
    values
    |> Enum.with_index
    |> Enum.map(fn({el, ind}) ->
      column = columns |> Enum.at(ind)
      attributes1 = legend |> Enum.find_value(fn({col, val, attributes}) -> if (col == column) && (val == el), do: attributes end)
    end)
    |> Enum.reject(fn(el) -> is_nil(el) end)
  end

  def distance(attr1, attr2) do
    attr1
    |> Enum.with_index
    |> Enum.map(fn({el, ind}) ->
      el1 =attr2 |> Enum.at(ind)
      attribute_distance(el,el1)
    end)
  end

  def attribute_distance(val, val) do
    0
  end

  def attribute_distance(["nil"], ["nil"]) do
    0
  end

  def attribute_distance(attribute1, ["nil"]) do
    attribute1 |> Enum.count
  end

  def attribute_distance(["nil"], attribute2) do
    attribute2 |> Enum.count
  end

  def attribute_distance(attribute1, attribute2) do
    distances =
      attribute1
      |> Enum.map(fn(word1) ->
        word1 = word1 |> to_charlist
        attribute2
        |> Enum.map(fn(word2) ->
          word2 = word2 |> to_charlist
          Levenshtein.distance(word1, word2)
        end)
        |> List.delete(0)
      end)
      |> List.flatten

     if Enum.empty?(distances), do: 0, else: Enum.min(distances)
  end
end
