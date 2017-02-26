defmodule MastersWork.Cluster.Clusterisation do
  def calculate_clusters(proximity_matrix_name, number_of_clusters) do
    script_path = Path.join([__DIR__, "../../../data/r_scripts/clusterisation.r"]) 
    params = 
      [
          proximity_matrix_name,
          number_of_clusters |> to_string
      ]


    {result, 0} = System.cmd(script_path, params)
    result |> parse_result
  end

  defp parse_result(result) do
    result
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reject(fn({_el, ind}) ->
      ind |> rem(2) != 1
    end)
    |> Enum.map(fn({el, _ind}) ->
      el |> String.split(" ")
    end)
    |> List.flatten
    |> Enum.reject(fn(el) ->
      el == ""
    end)
    |> Enum.map(&String.to_integer(&1))
  end
end
