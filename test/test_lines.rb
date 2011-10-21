$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

include GMath3D

main_view = Disp3D::View.new(100,100,200,200)

nodes = []

geoms = [FiniteLine.new(),
         FiniteLine.new(Vector3.new(), Vector3.new(Math::sqrt(2)/2, Math::sqrt(2)/2, 0)),
         FiniteLine.new(Vector3.new(), Vector3.new(0,1,0))]
nodes.push( Disp3D::NodeLines.new(geoms) )
nodes[0].color = [1,0,0]
main_view.world_scene_graph.add(nodes)

main_view.start
