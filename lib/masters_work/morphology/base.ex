defmodule MastersWork.Morphology.Base do
  alias MastersWork.Preprocessor
  alias MastersWork.Postprocessor
  alias MastersWork.Cluster.GapStat
  alias MastersWork.Cluster.Clusterisation
  alias MastersWork.Morphology.Proximity.Matrix

  @input_path "data/input/morphology.csv"
  @input_legend_path "data/input/morphology_legend_revised.csv"
  @output_matrix_path "data/output/morphology_matrix_hamming.csv"
  @expert_data_path "data/input/expert_data/*"

  def create_dissimilarity_matrix(distance_alg) do
    {values, columns, legend, _} = parse_initial_data

    Matrix.distance_matrix(values, columns, legend, distance_alg)
    |> Postprocessor.write(@output_matrix_path)
  end

  def classify_communities(number_of_clusters \\ 2) do
    file_name =
      @output_matrix_path
      |> String.split("/")
      |> List.last
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
end
