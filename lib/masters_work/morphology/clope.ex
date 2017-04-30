defmodule MastersWork.Morphology.Clope do
  alias MastersWork.Morphology.Base

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
