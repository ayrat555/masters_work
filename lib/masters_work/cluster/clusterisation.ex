defmodule MastersWork.Cluster.Clusterisation do
  def calculate_clusters(proximity_matrix_name, number_of_clusters) do
    script_path = Path.join([__DIR__, "../../../data/r_scripts/clusterisation.r"]) 
    params = 
      [
          proximity_matrix_name,
          number_of_clusters |> to_string
      ]


    System.cmd(script_path, params)
  end
end
