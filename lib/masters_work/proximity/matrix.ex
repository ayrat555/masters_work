defmodule MastersWork.Proximity.Matrix do
  alias MastersWork.Proximity.Measure
  alias MastersWork.Proximity.VectorParams

  def matrix(dataset, measure: measure) do
    dataset |> Enum.map(&vector(dataset, &1, measure))
  end

  defp vector(dataset, community_values, measure) do
    dataset |> Enum.map(&measure_vector_proximity(community_values, &1, measure))
  end

  defp measure_vector_proximity(vector1, vector2, measure) do
    VectorParams.params(vector1, vector2) |> Measure.proximity(measure: measure)
  end
end
