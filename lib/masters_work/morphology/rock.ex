defmodule MastersWork.Morphology.Rock do
  alias MastersWork.Morphology.Base
  alias MastersWork.Preprocessor
  @result_folder "./data/output/rock_clusters"
  @result_file_name "./data/output/rock_clusters/cluster"

  def clusterize(number_of_clusters, theta) do
    data_for_rock = prepare_data
    data_for_rock
    |> Rock.clusterize(number_of_clusters, theta)
    |> Enum.map(fn(cluster) ->
      cluster
      |> Enum.map(fn({community, _attrs}) ->
        community
      end)
    end)
  end

  def write_clusters(number_of_clusters, theta) do
    clusters = clusterize(number_of_clusters, theta)
    result_file_name = "#{@result_file_name}_#{number_of_clusters}_#{theta}.txt"

    File.mkdir(@result_folder)
    File.touch(result_file_name)
    {:ok, result_file} = File.open(result_file_name, [:write])

    clusters
    |> Enum.each(fn(cluster) ->
      IO.binwrite(result_file, "\n")

      cluster
      |> Enum.each(fn(community) ->
        IO.binwrite(result_file, community)
        IO.binwrite(result_file, ", ")
      end)
      IO.binwrite(result_file, "\n")
    end)

    File.close result_file
  end

  def sets_to_compare(number_of_clusters \\ 2, theta \\ 0.5) do
    rock_clusters = clusterize(number_of_clusters, theta)
    expert_clusters = Base.expert_data_dialects

    rock_cluster_set = rock_clusters |> Enum.map(&MapSet.new/1)
    expert_cluster_set = expert_clusters |> Enum.map(&MapSet.new/1)

    {rock_cluster_set, expert_cluster_set}
  end

  defp prepare_data do
    {communities, _, values} = Preprocessor.read("data/input/morphology.csv")

    values
    |> Enum.with_index
    |> Enum.map(fn({attrs, index}) ->
      attrs = attrs |> add_attr_index
      {_code, com} =
        communities
        |> Enum.at(index)

      {com, attrs}
    end)
  end

  defp add_attr_index(attrs) do
    attrs
    |> Enum.with_index
    |> Enum.map(fn({v, index}) ->
      "#{index}#{v}"
    end)
  end
end
