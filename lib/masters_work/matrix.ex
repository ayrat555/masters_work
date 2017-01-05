defmodule MastersWork.Matrix do
  def symmetric?(matrix) do
    transposed_matrix = transpose(matrix)
    transposed_matrix == matrix
  end

  def transpose(m) do
    attach_row(m, [])
  end

  defp attach_row([], result) do
    reverse_rows(result, [])
  end
  
  defp attach_row(row_list, result) do
    [first_row | other_rows] = row_list
    new_result = make_column(first_row, result, [])
    attach_row(other_rows, new_result)
  end

  defp make_column([], _, new) do
   Enum.reverse(new)
  end
  
  defp make_column(row, [], accumulator) do
    [row_head | row_tail] = row
    make_column(row_tail, [], [[row_head] | accumulator])
  end
  
  defp make_column(row, result, accumulator) do
    [row_head | row_tail] = row
    [result_head | result_tail] = result
    make_column(row_tail, result_tail, [[row_head | result_head] | accumulator])
  end

  defp reverse_rows([], result) do
    Enum.reverse(result)
  end
  
  defp reverse_rows([first|others], result) do
    reverse_rows(others, [Enum.reverse(first) | result])
  end
end
