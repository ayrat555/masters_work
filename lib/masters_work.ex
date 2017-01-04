defmodule MastersWork do
  @files [
         "../data/phonetics_vowels.csv",
         "../data/phonetics_consonantal.csv"
       ]

  def execute do
    {communities, column_names, values} = Preprocessor.read(@files)
    Measure.proximity_matrix(values)
  end
end
