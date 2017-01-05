defmodule MastersWork.Proximity.MatrixTest do
  use ExUnit.Case
  alias MastersWork.Proximity.Matrix, as: ProximityMatrix
  alias MastersWork.Matrix
  alias MastersWork.Preprocessor
  @input_datasets [
                    "data/input/phonetics_vowels.csv",
                    "data/input/phonetics_consonantal.csv"
                  ]

  test "makes symmetric matrix" do
    {_communities, _column_names, values} = Preprocessor.read(@input_datasets)
    matrix = ProximityMatrix.matrix(values, measure: 1)

    assert Matrix.symmetric?(matrix)
  end
end
