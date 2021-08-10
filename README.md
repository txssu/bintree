# Bintree

The module allows you to generate your own binary trees and display them beautifully.

## Installation

This package [available in Hex](https://hex.pm/packages/bintree) and can be installed
by adding `bintree` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bintree, "~> 1.1.0"}
  ]
end
```

## Usage

```elixir
Bintree.new(2, &(&1*2), &(&1 * 3), 4)  
|> IO.puts()

#   Result:
#               2               
#               |               
#       /---------------\       
#       |               |       
#       4               6       
#       |               |       
#   /-------\       /-------\   
#   |       |       |       |   
#   8      12      12      18   
#   |       |       |       |   
# /---\   /---\   /---\   /---\ 
# |   |   |   |   |   |   |   | 
#16  24  24  36  24  36  36  54 
```

[Documentation on hex](https://hexdocs.pm/bintree/readme.html).
