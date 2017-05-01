defmodule MastersWork.Morphology.Base do
  alias MastersWork.Preprocessor
  alias MastersWork.Postprocessor
  alias MastersWork.Cluster.GapStat
  alias MastersWork.Cluster.Clusterisation
  alias MastersWork.Morphology.Proximity.Matrix

  @input_path "data/input/morphology.csv"
  @input_legend_path "data/input/morphology_legend_revised.csv"
  @output_matrix_path "data/output/morphology_matrix_attr.csv"
  @expert_data_path "data/input/expert_data/*.txt"
  @expert_sub_data_path "data/input/expert_data/sub_dialects/*.txt"

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
    optimal_number_of_clusters = GapStat.calculate(file_name, number_of_clusters)

    Clusterisation.calculate_clusters(file_name, optimal_number_of_clusters)
  end

  def parse_initial_data do
    {communities, column_names, values} = Preprocessor.read(@input_path)
    columns = column_names |> columns
    legend = parse_legend

    {values, columns, legend, communities}
  end

  def check_with_expert_data(subset \\ nil) do
    cluster_result = classify_communities |> IO.inspect
    expert_result = expert_data_result(subset) |> IO.inspect

    correct_guesses =
      expert_result
      |> Enum.map(fn({el, index}) ->
        expert = cluster_result |> Enum.at(index)
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

  def expert_data_result(subset) do
    {communities, _, _} = Preprocessor.read(@input_path)

    expert_data =
      Path.wildcard(@expert_data_path)
      |> Enum.map(fn(path) -> path |> File.read! end)

    result = communities
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
    |> Enum.with_index

    if subset |> is_nil, do: result, else: result |> Enum.take_random(subset)
  end

  def expert_data_dialects do
    expert_data_classification(@expert_data_path)
  end

  def expert_data_subdialects do
    expert_data_classification(@expert_sub_data_path)
  end

  defp expert_data_classification(path) do
    {communities, _, _} = Preprocessor.read(@input_path)

    expert_data =
      Path.wildcard(path)
      |> Enum.map(fn(path) -> path |> File.read! end)

    result = communities
    |> Enum.map(fn({_, community_name}) ->
      dialect =
        expert_data
        |> Enum.find_index(fn(data) ->
        case :binary.match(data, community_name)  do
          {_, _} -> true
          :nomatch -> false
        end
      end)

      {community_name, dialect}
    end)

    dialect_count = Enum.count expert_data
    clusters =
      1..dialect_count
      |> Enum.map(fn(_) -> [] end)

    result
    |> Enum.reduce(clusters, fn({community, num}, temp_clusters) ->
      cluster =
        temp_clusters
        |> Enum.at(num)

      cluster = [community | cluster]


      temp_clusters |> List.replace_at(num, cluster)
    end)
  end
end
