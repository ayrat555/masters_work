defmodule MastersWork do
  alias MastersWork.Preprocessor
  alias MastersWork.Postprocessor
  alias MastersWork.Proximity.Matrix
  alias MastersWork.Cluster.GapStat

  @input_datasets [
                    "data/input/phonetics_vowels.csv",
                    "data/input/phonetics_consonantal.csv"
                  ]
  @proximity_matrix_output "data/output/proximity_matrix"
  @measures 1..5

  def execute(measures \\ @measures) do
    {_communities, _column_names, values} = Preprocessor.read(@input_datasets)

    measures
      |> Enum.each(fn(measure) -> Matrix.matrix(values, measure: measure) 
                                  |> Postprocessor.write(@proximity_matrix_output <> "#{measure}.csv") 
                    end)
    optimal_number_of_clusters = GapStat.calculate("proximity_matrix1.csv", 10)
    MastersWork.Cluster.Clusterisation.calculate_clusters("proximity_matrix1.csv", optimal_number_of_clusters)
  end
end
