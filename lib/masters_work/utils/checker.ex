defmodule MastersWork.Utils.Checker do
  def check_all(com_string) do
    "data/input/expert_data/sub_dialects/*.txt"
    |> Path.wildcard
    |> Enum.map(fn(path) ->
      check(com_string, path)
    end)
    |> Enum.filter(fn({_, perc}) ->
      perc != 0
    end)
    |> Enum.map(fn({subd, per}) ->
      "#{subd}: #{per}%"
    end)
  end

  def check(com_string, expert_com_path) do
    comms = com_string |> String.split(", ")
    expert_data = expert_com_path |> File.read!
    match_count =
      comms
      |> Enum.map(fn(com) ->
        :binary.match(expert_data, com)
      end)
      |> Enum.filter(fn(res) ->
        res != :nomatch
      end)
      |> Enum.count
      |> IO.inspect

      subd_name =
        expert_data
        |> String.split("\n")
        |> Enum.at(0)
        |> String.split("Говор: ")
        |> Enum.at(1)

      expert_comms =
        expert_data
        |> String.split("\n")
        |> IO.inspect
        |> Enum.filter(fn(str) ->
          str
          |> String.starts_with?(["1", "2", "3", "4", "5", "-"])
        end)
        |> Enum.count
        |> IO.inspect

     {subd_name, (match_count / expert_comms) * 100}
  end
end
