/***
 * Excerpted from "Exploring Graphs with Elixir",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/thgraphs for more book information.
***/
g = graph.traversal()

a = g.addV('a').next()
b = g.addV('b').next()
a.addE('EX', b).to(b).iterate()
