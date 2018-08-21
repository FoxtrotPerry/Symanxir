# Symanxir

What is it?
------

Symanxir is a lightweight Elixir package that aims to reduce data down to it's pure symantic meaning in a way that is helpful for both data analytics and data management.

Why use it?
------

Symanxir was spawned from a problem I was posed with at work that had no clear open source solution at the time (as far as I could tell, anyways).

The premise of the problem was that I had two spreadsheets that were talking about the same people. Both spreadsheets had valuable info about the people that I needed to combine and manipulate.

Problem was, because of human errors like the inclusion of nicknames, abbreviations, typos, etc, matching the people and their data between the two spreadsheets would be nearly impossible when combined with the absence of any unique key unless I were to do it all by hand.

So instead I made Symanxir. By using a weight based derivative of [the Jaro-Winkler distance](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance), we can derive symantic meaning from points of data you pass in. This will allow us to match data points between lists without any sort of uniquely identifying information.

---

## Installation
> Note: Not available on Hex quite yet, it's coming though... 

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `symanxir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:symanxir, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/symanxir](https://hexdocs.pm/symanxir).

---

## Sounds cool, so how do I use it?

By design, Symanxir plays very nicely with [CSV](https://github.com/beatrichartz/csv) which allows for effortless spreadsheet parsing in your project.

Having said that, the import of CSV is not required to use Symanxir at the moment. 

> Note: In the future, CSV might be integrated into Symanxir. But due to the impact to size this might cause, further deliberation will be needed...

### Symanxir.match()

Assuming you have two lists whose elements are of equal lengths,

```elixir
list1 = [["Franky","Roosevelt","Hide Park","NY","12538"],
         ["Vermin","Supreme","Rockport","MA","01966"],
         ["Caleb","Perry","Raleigh","NC","27676"]]

list2 = [["Vernin","Supreme","Rockport","MA","1966"],
         ["Kaleb","Perry","Raleigh","NC","27676"],
         ["Franklin","Rossevelt","Hyde Park","NY","12538"]]
```

You can use:

```elixir
Symanxir.match(list1, list2)
```

Or optionally, you can use a weight list that will emphasize the importance of each field when matching like so (the greater the number the *'heavier'* the field becomes when deciding certainty ):

```elixir
weight = [0.25, 0.50, 0.25, 0.50, 1.00]
```

```elixir
Symanxir.match(list1, list2, weight)
```

Which when ran, will return a list of matches accompanied with a number representing how confident the algorithm is that it found the cooresponding data row for the row in `list1` that it was looking for in `list2`. For example, the output for our example above is as follows:

#### Output w/ weight array:
```elixir
[[2, 95.9722222222], [0, 95.5555555556], [1, 98.6666666667]]
```

#### Output w/o weight array:
```elixir
[SymanCheck] "Weight list not given, calculating standard weight..."
[[2, 93.4259259259], [0, 95.1111111111], [1, 97.3333333333]]
```

*Note the slight differences in certainty values*