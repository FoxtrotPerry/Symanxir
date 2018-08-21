defmodule SymanxirTest do
  use ExUnit.Case

  setup_all() do
    elem1 = [["Terry","Davis","West Allis","WI","53214"],
             ["Caleb","Perry","Raleigh","NC","27676"],
             ["Eleanor","Roosevelt","Hye Park","NY","12538"],
             ["Vermin","Supreme","Rockport","MA","01966"],
             ["Norm","Perri","Skowhegan","ME","4976"],
             ["Franky","Roosevelt","Hide Park","NY","12538"]]

    elem2 = [["Caleb","Perry","Raleigh","NC","27676"],
             ["Norman","Perry","Skowhegan","ME","4976"],
             ["Franklin","Roosevelt","Hyde Park","NY","12538"],
             ["Vermin","Supreme","Rockport","MA","1966"],
             ["Terry","Davis","West Allis","WI","53214"],
             ["Eleanor","Rossevelt","Hyde Park","NY","12538"]]

    elem_error = [["Caleb","Perry","Raleigh","NC","27676"],
             ["Norman","Perry","Skowhegan","ME","4976"],
             ["Franklin","Rossevelt","Hyde Park","NY","12538","Error Location #1"],
             ["Vermin","Supreme","Rockport","MA","1966"],
             ["Terry","Davis","West Allis","WI","53214","Error Location #2"],
             ["Eleanor","Rossevelt","Hyde Park","NY","12538"]]

    ex_list1 = [["Franky","Roosevelt","Hide Park","NY","12538"],
             ["Vermin","Supreme","Rockport","MA","01966"],
             ["Caleb","Perry","Raleigh","NC","27676"]]

    ex_list2 = [["Vernin","Supreme","Rockport","MA","1966"],
             ["Kaleb","Perry","Raleigh","NC","27676"],
             ["Franklin","Rossevelt","Hyde Park","NY","12538"]]

    weight = [0.25,0.50,0.25,0.50,1.00]
    %{elem1: elem1, elem2: elem2, weight: weight,
     elem_error: elem_error, ex_list1: ex_list1, ex_list2: ex_list2}
  end

  test "certainty scores are as expected with no weight", context do
    resp = Symanxir.match(context[:elem1],context[:elem2])
    assert resp == [
      [4, 100.0],
      [0, 100.0],
      [5, 97.7777777778],
      [3, 98.6666666667],
      [1, 95.1111111111],
      [2, 94.9074074074]
    ]
  end

  test "certainty scores are as expected with weight", context do
    resp = Symanxir.match(context[:elem1],context[:elem2],context[:weight])
    assert resp == [
      [4, 100.0],
      [0, 100.0],
      [5, 98.1481481481],
      [3, 97.3333333333],
      [1, 96.2222222222],
      [2, 97.4537037037]
    ]
  end

  test "can handle errored list gracefully", context do
    resp = Symanxir.match(context[:elem_error], context[:elem2])
    assert resp == "Error when checking data validity, check tuple above."
  end
end
