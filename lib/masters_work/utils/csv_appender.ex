defmodule MastersWork.Helpers.CsvAppender do
  def create_legend_csv(input_legend_path, output_csv_path) do
    input_legend_path
    |> preprocess
    |> write_to_file(output_csv_path)
  end

  defp preprocess(input) do
    input
    |> File.stream!
    |> Enum.map(fn(line) -> line |> clean_line end)
    |> form_lines
    |> IO.inspect
    |> Enum.map(fn(line) -> line |> csv_line end)
    |> Enum.join("\n")
  end

  defp clean_line(line) do
    line
    |> String.replace("\n", "")
    |> String.trim
  end

  defp csv_line(elements) do
    elements
    |> Enum.reduce(fn(el, ac) -> "#{ac};#{el}" end)
  end

  defp write_to_file(data, file_path) do
    file_path |> File.write(data, [:write])
  end

  defp form_lines(array, accumulator \\ [], result \\ [])

  defp form_lines([head|[]], accumulator, result) do
    accumulator = accumulator ++ [head]
    result ++ [accumulator]
  end

  defp form_lines([head|tail], accumulator, result) do
    if integer?(head) do
      result = result ++ [accumulator]
      accumulator = [head]
    else
      accumulator = accumulator ++ [head]
    end

    form_lines(tail, accumulator, result)
  end

  defp integer?(string) do
    magic = 69
    case Integer.parse(string) do
      {int, ""} -> if int > magic, do: true, else: false
      _ -> false
    end
  end
end
