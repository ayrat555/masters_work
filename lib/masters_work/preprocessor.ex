defmodule MastersWork.Preprocessor do
  def read(dataset_paths) do
    datasets = for data_path <- dataset_paths, do: read_data(data_path)
    :ok = datasets |> validate_correspondance
    datasets |> merge_datasets
  end

  defp read_data(path) do
    path = Path.join([__DIR__, "../..", path]) 
    csv_lines = File.stream!(path) |> CSV.decode
    column_names = csv_lines |> Enum.at(0) |> Enum.slice(5..-1)
    [ _ | data] = csv_lines |> Enum.to_list
    communities = for community_values <- data, do: { Enum.at(community_values, 1), Enum.at(community_values, 4) }
    values = for community_values <- data, do: Enum.slice(community_values, 5..-1)

    {communities, column_names, values}
  end

  defp validate_correspondance(datasets) do
    {communities, _, _} = datasets |> Enum.at(0)
    [remaining_datasets | _] = datasets
    
    _validate_correspondance(remaining_datasets, communities)
  end

  defp _validate_correspondance(datasets, first_communities) when is_list(datasets) do
    if Enum.all?(datasets, fn [cur_communities | _] -> cur_communities == first_communities end) do
      :ok
    else
      :error
    end
  end

  defp _validate_correspondance(dataset, first_communities) do
    {communities, _, _} = dataset
    if communities == first_communities do
      :ok
    else
      :error
    end
  end

  defp merge_datasets(datasets) do
    {communities, _, _} = datasets |> Enum.at(0)

    merged_values = 
      datasets
      |> Enum.map(fn {_, _, dataset_values} -> dataset_values end)
      |> Enum.reduce(fn dataset_values, acc -> Enum.zip(acc, dataset_values) end)
      |> Enum.map(fn {ar1, ar2} -> ar1 ++ ar2 end)

    merged_column_names =
      datasets
      |> Enum.map(fn {_, column_names, _} -> column_names end)
      |> Enum.reduce(fn column_names, acc -> acc ++ column_names end)

    {communities, merged_column_names, merged_values}
  end
end
