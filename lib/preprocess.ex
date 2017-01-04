defmodule Preprocessor do
  @files [
           "../data/phonetics_vowels.csv",
           "../data/phonetics_consonantal.csv"
         ]

  def read do
    datasets = for data_path <- @files, do: read_data(data_path)
    :ok = datasets |> validate_correspondance
  end

  defp read_data(path) do
    path = Path.join([__DIR__, path]) 
    csv_lines = File.stream!(path) |> CSV.decode
    column_names = csv_lines |> Enum.at(0) |> drop_head(4)
    [ _ | data] = csv_lines |> Enum.to_list
    communities = for community_values <- data, do: { Enum.at(community_values, 1), Enum.at(community_values, 4) }
    values = for community_values <- data, do: drop_head(community_values, 4)

    {communities, column_names, values}
  end

  defp drop_head(list, n) when is_list(list) do
    _drop_head(list, 0, n)
  end
  
  defp _drop_head([_head | tail], current, n) when current == n do
    tail
  end

  defp _drop_head([_head | tail], current, n) when current < n do
    _drop_head(tail, current + 1, n)
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

  # defp validate_correspondance(first_list, second_list) do
  #   first_list_size = Enum.size(first_list)
  #   second_list_size = Enum.size(second_list)

  #   if first_list_size == second_list_size, do: _validate_correspondance(first_list, second_list, first_list_size, 0)
  #                                           else: false
  # end
  
  # defp _validate_correspondance(first_list, second_list, size, cur) when size - 1 == cur do
  #   if Enum.at(first_list) == Enum.at(second_list), do: true, 
  #                                                   else: false
  # end  

  # defp _validate_correspondance(first_list, second_list, size, cur) do
  #   first_list_el = Enum.at(first_list, cur)
  #   second_list_el = Enum.at(second_list, cur)

  #   if  first_list_el == second_list_el, do: validate_correspondance(first_list, second_list, cur + 1)
  #                                        else: false
  # end
end
