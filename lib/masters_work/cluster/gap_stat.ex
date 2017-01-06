defmodule MastersWork.Cluster.GapStat do
  def calculate(proximity_matrix_name, max_number_of_clusters) do
    script_path = Path.join([__DIR__, "../../../data/r_scripts/gap_stat.r"])
    params = 
      [
          proximity_matrix_name,
          max_number_of_clusters |> to_string
      ]

    {result, 0} = System.cmd(script_path, params)
    result |> parse_number_of_clusters
  end

  defp parse_number_of_clusters(result) do
    result 
    |> String.split("\n") 
    |> Enum.at(3) 
    |> String.split(" ") 
    |> List.last
    |> String.to_integer
  end
end
