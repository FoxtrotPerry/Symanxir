defmodule Symanxir do # Peep dis https://i.imgur.com/OKpFa15.jpg
  def match(elem1, elem2, weight \\ [], opts \\ :default) do #(list,list,list,atom)

    weight = weight_check(weight,elem1)

    d_check = datacheck(elem1,elem2,weight,opts)
    if(d_check == :ok) do

      weight_tot = Enum.reduce(weight, 0.0, fn(x,acc) ->
        acc = acc + x
      end)

      IO.inspect weight, label: "Weight at first loop"

      match_list = Enum.reduce(elem1,[], fn(x,acc) -> # x = next elem from elem1

        match_elem = Enum.reduce(elem2, [0, 0.0, 0], fn(y,syn) -> # y = next elem from elem2
                                       #[match_pos,jaro,index]
          i = Enum.at(syn,2)
          match_pos = Enum.at(syn,0)
          if(opts == :debug) do
            IO.inspect y, label: "Jaro Calc for"
            IO.inspect x, label: "Jaro Calc for"
          end

          [jaro_score, index] = Enum.reduce(y, [0.0,0], fn(z,ack) -> # z = next elem from in y
            index = Enum.at(ack,1)
            if(opts == :debug) do
               IO.inspect(Enum.at(x,index) <> " + " <> z, label: "Now matching")
            end
            jaro =
            String.jaro_distance(Enum.at(x,index),z) * Enum.at(weight,index)
            if (opts == :debug) do
              IO.inspect jaro
            end
            [Enum.at(ack,0) + jaro, index+1]
          end)
          if (opts == :debug) do
            IO.inspect(jaro_score, label: "jaro_score")
            IO.inspect(weight_tot, label: "weight_tot")
          end
          jaro_final = (jaro_score/weight_tot)*100
          |> Float.round(10)
          if(opts == :debug) do
            IO.inspect jaro_final, label: "Final Jaro"
            IO.puts ""
          end

          if(jaro_final > Enum.at(syn,1)) do
            if(opts == :debug) do
              warn("New High Jaro Score: " + jaro_final)
              IO.puts ""
            end
            [i,jaro_final,i+1]
          else
            [match_pos,Enum.at(syn,1),i+1]
          end

        end)
        if(opts == :debug) do
          IO.inspect match_elem, label: "WINNER"
          IO.puts "=================================================================================="
        end
        {_,scrubbed_match_elem} = List.pop_at(match_elem,2)
        acc ++ [scrubbed_match_elem]
      end)

    else
      IO.inspect d_check
      error("Error when checking data validity, check tuple above.")
    end
  end



  defp weight_check(weight_list,elem1) do
    return_weight_list =
      case weight_list do
        [] ->
          warn("Weight list not given or is empty, calculating standard weight...")
          Enum.reduce(Enum.at(elem1,0),[],fn(x,acc) ->
            acc ++ [Float.round(1/(length(Enum.at(elem1,0))),8)]
          end)
        _ -> weight_list
      end
    IO.inspect return_weight_list, label: "Weight List"
    return_weight_list
  end

  defp error(string) do
    safe_string = Kernel.inspect(string)
    [:red, "[Symanxir] "<> safe_string]
    |> IO.ANSI.format
    |> IO.puts
    string
  end

  defp print(string) do
    safe_string = Kernel.inspect(string)
    [:green, "[Symanxir] "<> safe_string]
    |> IO.ANSI.format
    |> IO.puts
    string
  end

  defp warn(string) do
    safe_string = Kernel.inspect(string)
    [:yellow, "[Symanxir] "<> safe_string]
    |> IO.ANSI.format
    |> IO.puts
    string
  end

  defp datacheck(elem1,elem2,weight,opts) do
    if(length(elem1) && length(elem2)) do
      elem1_firstlen = length(Enum.at(elem1,0))
      elem2_firstlen = length(Enum.at(elem2,0))
      [e1_status,index,e1_errors] = elem_length_check(elem1,elem1_firstlen)
      [e2_status,index,e2_errors] = elem_length_check(elem2,elem2_firstlen)
      if(e1_status==:ok && e2_status==:ok) do
        if(opts == :status) do
          print("Data is valid.")
        end
        :ok
      else
        if(opts == :status) do
          error("Data is found as NOT valid.")
        end
        if(Enum.empty?(e1_errors)) do
          {:error, e2_errors}
        else
          {:error, e1_errors}

        end

      end
    else
      {:error, "One or both passed lists are empty"}
    end
  end

  defp elem_length_check(list, master_length) do
    return = Enum.reduce(list, [:ok,0,[]], fn(x,acc) -> #[status,index,[error_locations]]
      pos = Enum.at(acc,1)
      errors = Enum.at(acc,2)
      cond do
        ((length(x) == master_length) && Enum.at(acc,0) == :ok) -> [:ok, pos+1, errors]
        ((length(x) == master_length) && Enum.at(acc,0) == :error) -> [:error, pos+1, errors]
        (length(x) != master_length) -> [:error, pos+1, errors ++ [pos]]
      end
    end)
  end
end
