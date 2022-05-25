#---
# Excerpted from "Exploring Graphs with Elixir",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/thgraphs for more book information.
#---
defmodule NativeGraph.Serializers.CSV do
  use NativeGraph.Serializer
  alias NativeGraph.Serializer

  def serialize(%Graph{type: type} = g) do
    result = serialize_nodes(g)
    {:ok, result}
  end

  def serialize_nodes(%Graph{vertices: vertices} = g) do

    table_data =
      # vertices
      Graph.vertices(g)
      |> Enum.reduce(
        [],
        fn node, table ->
          table ++ [%{"id" => node}]
        end
      )

    table_data
    |> CSV.encode(delimiter: "\n", headers: ["id"])
    |> Enum.each(&IO.write(&1))

  end

  defp serialize_edges(%Graph{type: type, vertices: vertices, out_edges: oe, edges: em} = g) do
    edges =
      Enum.reduce(vertices, [], fn {id, v}, acc ->
        v_label = Serializer.get_vertex_label(g, id, v)

        edges =
          oe
          |> Map.get(id, MapSet.new())
          |> Enum.flat_map(fn id2 ->
            v2_label = Serializer.get_vertex_label(g, id2, Map.get(vertices, id2))

            Enum.map(Map.fetch!(em, {id, id2}), fn
              {nil, weight} ->
                {v_label, v2_label, weight}

              {label, weight} ->
                {v_label, v2_label, weight, Serializer.encode_label(label)}
            end)
          end)

        case edges do
          [] -> acc
          _ -> acc ++ edges
        end
      end)

    arrow = if type == :directed, do: "->", else: "--"

    Enum.reduce(edges, "", fn
      {v_label, v2_label, weight, edge_label}, acc ->
        acc <>
          Serializer.indent(1) <>
          v_label <>
          " #{arrow} " <> v2_label <> " [" <> "label=#{edge_label}; weight=#{weight}" <> "]\n"

      {v_label, v2_label, weight}, acc ->
        acc <>
          Serializer.indent(1) <>
          v_label <> " #{arrow} " <> v2_label <> " [" <> "weight=#{weight}" <> "]\n"
    end)
  end
  
end
