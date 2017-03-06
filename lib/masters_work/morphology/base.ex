defmodule  MastersWork.Morphology.Base do
  alias MastersWork.Preprocessor
  alias MastersWork.Helpers.Levenshtein
  alias MastersWork.Postprocessor
  alias MastersWork.Cluster.GapStat
  alias MastersWork.Cluster.Clusterisation

  @input_path "data/input/morphology.csv"
  @input_legend_path "data/input/morphology_legend_revised.csv"
  @output_matrix_path "data/output/morphology_matrix_levenshtein.csv"
  @expert_data_path "data/input/expert_data/*"

  def create_dissimilarity_matrix do
    {values, columns, legend, _} = parse_initial_data

    distance_matrix(values, columns, legend)
    |> normalize_matrix
    |> Postprocessor.write(@output_matrix_path)
  end

  def classify_communities(number_of_clusters \\ 2) do
    file_name = "morphology_matrix_levenshtein.csv"
    optimal_number_of_clusters = GapStat.calculate(file_name, number_of_clusters) |> IO.inspect

    Clusterisation.calculate_clusters(file_name, optimal_number_of_clusters)
  end

  def parse_initial_data do
    {communities, column_names, values} = Preprocessor.read(@input_path)
    columns = column_names |> columns
    legend = parse_legend

    {values, columns, legend, communities}
  end

  def check_with_expert_data do
    cluster_result = classify_communities |> IO.inspect
    expert_result = expert_data_result |> IO.inspect

    correct_guesses =
      cluster_result
      |> Enum.with_index
      |> Enum.map(fn({el, index}) ->
        expert = expert_result |> Enum.at(index)
        case expert do
          ^el -> 1
          _ -> 0
        end
      end)
      |> Enum.reject(fn(el) -> el == 0 end)
      |> Enum.count

    correct_guesses / Enum.count(expert_result)
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
    |> Enum.with_index
    |> Enum.map(fn({val1, ind}) ->
      IO.inspect ind
      atr1 = attributes(val1, columns, legend)
      data
      |> Enum.map(fn(val2) ->
        atr2 = attributes(val2, columns, legend)
        dist = distance(atr1, atr2)
        Enum.sum(dist) / Enum.count(atr2)
      end)
    end)
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

  def distance(attr1, attr2) do
    attr1
    |> Enum.with_index
    |> Enum.map(fn({el, ind}) ->
      el1 =attr2 |> Enum.at(ind)
      attribute_distance(el,el1)
    end)
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

  def expert_data_result do
    {communities, _, _} = Preprocessor.read(@input_path)

    expert_data =
      Path.wildcard(@expert_data_path)
      |> Enum.map(fn(path) -> path |> File.read! end)

    communities
    |> Enum.map(fn({_, community_name}) ->
      expert_data
      |> Enum.find_index(fn(data) ->
        case :binary.match(data, community_name)  do
          {_, _} -> true
          :nomatch -> false
         end
      end)
    end)
    |> Enum.map(fn(cluster) ->
      cluster + 1
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
