#---
# Excerpted from "Exploring Graphs with Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/thgraphs for more book information.
#---
defmodule PropertyGraph.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Bolt.Sips, Application.get_env(:bolt_sips, Bolt)}
    ]

    opts = [strategy: :one_for_one, name: PropertyGraph.Service]
    Supervisor.start_link(children, opts)
  end

end
