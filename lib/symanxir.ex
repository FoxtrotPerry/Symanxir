defmodule Symanxir do # Peep dis https://i.imgur.com/OKpFa15.jpg
  def match(elem1, elem2, weight \\ [], opts \\ :default) do #(list,list,list,atom)

    if(Enum.empty?(weight)) do
      warn("Weight not given, calculating standard weight...")
      {_,weight} = Enum.reduce(elem1,[],fn(x,acc) ->
        new_acc = acc ++ [Float.round(1/(length(elem1)),10)]
      end)|> List.pop_at(0)
    end

    d_check = datacheck(elem1,elem2,weight)
    if(d_check == :ok) do

      weight_tot = Enum.reduce(weight, 0.0, fn(x,acc) ->
        acc = acc + x
      end)

      match_list = Enum.reduce(elem1,[], fn(x,acc) -> # x = next elem from elem1

        match_elem = Enum.reduce(elem2, [0,0.0,0], fn(y,syn) -> # y = next elem from elem2
                                       #[match_pos,jaro,index]
          i = Enum.at(syn,2)
          match_pos = Enum.at(syn,0)
          IO.inspect y, label: "Jaro Calc for"
          IO.inspect x, label: "Jaro Calc for"

          [jaro_score, index] = Enum.reduce(y, [0.0,0], fn(z,ack) -> # z = next elem from in y
            index = Enum.at(ack,1)
            # IO.inspect(Enum.at(x,index) <> " + " <> z, label: "Now matching")
            jaro =
            String.jaro_distance(Enum.at(x,index),z) * Enum.at(weight,index)
            |> IO.inspect
            [Enum.at(ack,0) + jaro, index+1]
          end)
          IO.inspect(jaro_score, label: "jaro_score")
          IO.inspect(weight_tot, label: "weight_tot")
          jaro_final = (jaro_score/weight_tot)*100
          |> Float.round(10)
          |> IO.inspect label: "Final Jaro"
          IO.puts ""

          if(jaro_final > Enum.at(syn,1)) do
            IO.inspect jaro_final, label: "New High Jaro"
            IO.puts ""
            [i,jaro_final,i+1]
          else
            [match_pos,Enum.at(syn,1),i+1]
          end

        end)
        IO.inspect match_elem, label: "WINNER"
        IO.puts "=================================================================================="
        acc ++ [match_elem]
      end)

    else
      IO.inspect d_check
      error("Ut-Oh")
    end
  end





  defp error(string) do
    [:red, "\n[SymanCheck] "<> string]
    |> IO.ANSI.format
    |> IO.puts
    string
  end

  defp print(string) do
    safe_string = Kernel.inspect(string)
    [:green, "\n[SymanCheck] "<> safe_string]
    |> IO.ANSI.format
    |> IO.puts
    string
  end

  defp warn(string) do
    safe_string = Kernel.inspect(string)
    [:yellow, "\n[SymanCheck] "<> safe_string]
    |> IO.ANSI.format
    |> IO.puts
    string
  end

  defp datacheck(elem1,elem2,weight) do
    if(length(elem1) && length(elem2)) do
      elem1_firstlen = length(Enum.at(elem1,0))
      elem2_firstlen = length(Enum.at(elem2,0))
      [e1_status,index,errors] = elem_length_check(elem1,elem1_firstlen)
      [e2_status,index,errors] = elem_length_check(elem2,elem2_firstlen)
      if(e1_status==:ok && e2_status==:ok) do
        :ok
      else
        {:error, errors}
      end
    else
      {:error, "One or both passed lists are empty"}
    end
  end

  defp elem_length_check(list, master_length) do
    return = Enum.reduce(list, [:ok,0,[nil]], fn(x,acc) -> #[status,index,[error_locations]]
      pos = Enum.at(acc,1)
      errors = Enum.at(acc,2)
      if(length(x) == master_length) do
        [:ok, pos+1, errors]
      else
        [:error, pos+1, errors ++ [pos]]
      end
    end)
  end
end
