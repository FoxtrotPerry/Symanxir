defmodule SymanxirTest do
  use ExUnit.Case

  setup_all() do
    elem1 = [["Terry","Davis","West Allis","WI","53214"],
             ["Caleb","Perry","Raleigh","NC","27676"],
             ["Eleanor","Rossevelt","Hye Park","NY","12538"],
             ["Vermin","Supreme","Rockport","MA","1966"],
             ["Norm","Perri","Skowhegan","ME","4976"],
             ["Franky","Rossevelt","Hide Park","NY","12538"]]

    elem2 = [["Caleb","Perry","Raleigh","NC","27676"],
             ["Norman","Perry","Skowhegan","ME","4976"],
             ["Franklin","Rossevelt","Hyde Park","NY","12538"],
             ["Vermin","Supreme","Rockport","MA","1966"],
             ["Terry","Davis","West Allis","WI","53214"],
             ["Eleanor","Rossevelt","Hyde Park","NY","12538"]]

    elem_error = [["Caleb","Perry","Raleigh","NC","27676"],
             ["Norman","Perry","Skowhegan","ME","4976"],
             ["Franklin","Rossevelt","Hyde Park","NY","12538","Error Location Found"],
             ["Vermin","Supreme","Rockport","MA","1966"],
             ["Terry","Davis","West Allis","WI","53214"],
             ["Eleanor","Rossevelt","Hyde Park","NY","12538"]]

    weight = [0.25,0.50,0.25,0.50,1.00]
    %{elem1: elem1, elem2: elem2, weight: weight, elem_error: elem_error}
  end

  test "certainty scores are as expected with no weight", context do
    resp = Symanxir.match(context[:elem1],context[:elem2])
    IO.inspect resp, label: "No Weight RESP"
  end

  test "certainty scores are as expected with weight", context do
    resp = Symanxir.match(context[:elem1],context[:elem2],context[:weight])
    IO.inspect resp, label: "With Weight RESP"
  end
end
