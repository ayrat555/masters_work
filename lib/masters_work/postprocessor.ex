defmodule MastersWork.Postprocessor do
  def write(data, path) do
    path = Path.join([__DIR__, "../..",  path]) 
    file = File.open!(path, [:write, :utf8])
    data |> CSV.encode |> Enum.each(&IO.write(file, &1))
  end
end
