defmodule MastersWork.Morphology.Proximity.Distance do
  alias TheFuzz.Similarity.Levenshtein
  alias TheFuzz.Similarity.Hamming
  alias TheFuzz.Similarity.Jaccard
  alias TheFuzz.Similarity.DiceSorensen
  alias TheFuzz.Similarity.Overlap

  def distance(attr1, attr2, {:attr, alg}) do
    attr1 = attr1 |> Enum.join("")
    attr2 = attr2 |> Enum.join("")

    word_distance(attr1, attr2, alg)
  end

  def distance(attr1, attr2, distance_alg) do
    attr1
    |> Enum.with_index
    |> Enum.map(fn({el, ind}) ->
      el1 = attr2 |> Enum.at(ind)
      attribute_distance(el, el1, distance_alg)
    end)
  end

  def attribute_distance(val, val, _) do
    0
  end

  def attribute_distance(["nil"], ["nil"], _) do
    0
  end

  def attribute_distance(attribute1, ["nil"], _) do
    attribute1 |> Enum.count
  end

  def attribute_distance(["nil"], attribute2, _) do
    attribute2 |> Enum.count
  end

  def attribute_distance(attribute1, attribute2, distance_alg) do
    distances =
      attribute1
      |> Enum.map(fn(word1) ->
        word1 = word1 |> to_charlist

        attribute2
        |> Enum.map(fn(word2) ->
          word2 = word2 |> to_charlist
          word_distance(word1, word2, distance_alg)
        end)
        |> List.delete(0)
      end)
      |> List.flatten

     if Enum.empty?(distances), do: 0, else: Enum.min(distances)
  end

  def word_distance(word1, word2, :levenshtein) do
    Levenshtein.compare(word1, word2)
  end

  def word_distance(word1, word2, :hamming) do
    Hamming.compare(word1, word2)
  end

  def word_distance(word1, word2, :jaccard) do
    Jaccard.compare(word1, word2)
  end

  def word_distance(word1, word2, :dice_sorensen) do
    DiceSorensen.compare(word1, word2)
  end

  def word_distance(word1, word2, :overlap) do
    Overlap.compare(word1, word2)
  end
end
