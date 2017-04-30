defmodule MastersWork.Morphology.Clope do
  alias MastersWork.Morphology.Base
  @result_folder "./data/output/clope_clusters"
  @result_file_name "./data/output/clope_clusters/cluster.txt"

  def clusterize(repulsion) do
    data_for_clope = prepare_data
    data_for_clope
    |> Clope.clusterize(repulsion)
    |> Enum.map(fn(cluster) ->
      cluster
      |> Enum.map(fn({community, _attrs}) ->
        community
      end)
    end)
  end

  def write_clusters(repulsion) do
    clusters = clusterize(repulsion)

    File.mkdir(@result_folder)
    File.touch(@result_file_name)
    {:ok, result_file} = File.open(@result_file_name, [:write])

    clusters
    |> Enum.each(fn(cluster) ->
      IO.binwrite(result_file, "\n")

      cluster
      |> Enum.each(fn(community) ->
        IO.binwrite(result_file, community)
        IO.binwrite(result_file, "\n")
      end)
    end)

    File.close result_file
  end

  defp prepare_data do
    {values, _columns, _legend, communities} = Base.parse_initial_data

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
