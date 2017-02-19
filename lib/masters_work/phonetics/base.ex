defmodule MastersWork.Phonetics.Base do
  alias MastersWork.Preprocessor
  alias MastersWork.Helpers.Levenshtein

  @input_path "data/input/morphology.csv"
  @input_legend_path "data/input/morphology_legend_revised.csv"

  def execute do
    {communities, column_names, values} = Preprocessor.read(@input_path)
    data = form_data(communities, values)
    columns = column_names |> columns
    legend = parse_legend
  end

  def parse_legend do
    lines = File.stream!(@input_legend_path) |> CSV.decode(separator: ?;) |> Enum.to_list
    for [num, value, words] <- lines do
      {col_int, ""} = Integer.parse(num)
      {col_int, value, String.split(words,",")}
    end
  end

  def form_data(communities, values)  do
    community_with_values = for community <- communities, community_values <- values do
      {community, community_values}
    end
  end

  def columns(column_names) do
    for col <- column_names do
      {int, _} = col |> String.replace("Карта", "") |> String.trim |> Integer.parse
      int
    end
  end

  def attrinute_distance(["nil"], ["nil"]) do
    0
  end

  def attrinute_distance(attribute1, ["nil"]) do
    attribute1 |> Enum.count
  end

  def attrinute_distance(["nil"], attribute2) do
    attribute2 |> Enum.count
  end

  def attribute_distance(attribute1, attribute2) do
    distances =
      attribute1
      |> Enum.map(fn(word1) ->
        attribute2
        |> Enum.map(fn(word2) ->
          Levenshtein.distance(word1, word2)
        end)
        |> List.delete(0)
      end)
      |> List.flatten

     if Enum.empty?(distances), do: 0, else: Enum.min(distances)
  end
end
