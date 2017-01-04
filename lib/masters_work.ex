defmodule MastersWork do
  alias MastersWork.Preprocessor
  alias MastersWork.Proximity.Matrix

  @files [
         "data/phonetics_vowels.csv",
         "data/phonetics_consonantal.csv"
       ]

  def execute(measure) do
    {_communities, _column_names, values} = Preprocessor.read(@files)
    Matrix.matrix(values, measure: measure)
  end
end
