defmodule MastersWork.Phonetics.Measure do
  def proximity(%{a: a, b: b, c: c, d: d, f: f}, measure: measure) when measure == 1 do
    (a + d) / (a + b + c + d + f)
  end

  def proximity(%{a: a, b: b, c: c, d: d, f: f}, measure: measure) when measure == 2 do
    2 * (a + d) / (2 * (a + d) + c + b + f)
  end

  def proximity(%{a: a, b: b, c: c, d: d, f: f}, measure: measure) when measure == 3 do
    (a + d) / (a + 2 * (b + c + f) + d)
  end

  def proximity(%{a: a, b: b, c: c, d: d, f: f}, measure: measure) when measure == 4 do
    d / (a + b + c + d + f)
  end

  def proximity(%{b: b, c: c, d: d, f: f}, measure: measure) when measure == 5 do
    d / (b + c + d + f)
  end

  def proximity(%{a: a, b: b, c: c, f: f}, measure: measure) when measure == 6 do
    a / (b + c + a + f)
  end
end
