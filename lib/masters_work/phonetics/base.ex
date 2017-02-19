defmodule MastersWork.Phonetics.Base do
  alias MastersWork.Preprocessor

  @input_path "data/input/morphology.csv"
  @input_legend_path "data/input/morphology_legend_revised.csv"

  def execute do
    {communities, column_names, values} = Preprocessor.read(@input_path)
  end

  def legend do
    lines = File.stream!(@input_legend_path) |> CSV.decode(separator: ?;) |> Enum.to_list |> IO.inspect
    for [num, value, words] = line <- lines, do: {num, value, String.split(words,",")}
  end
end
