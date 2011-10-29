$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

include GMath3D

main_view = Disp3D::GLUTWindow.new(400,400)

nodes = []

geoms = [FiniteLine.new(),
         FiniteLine.new(Vector3.new(), Vector3.new(Math::sqrt(2)/2, Math::sqrt(2)/2, 0)),
         FiniteLine.new(Vector3.new(), Vector3.new(0,1,0))]
nodes.push( Disp3D::NodeLines.new(geoms) )
nodes[0].material_color = [1,0,0,1]

vertices1 = Array.new(6)
vertices1[0] = Vector3.new(1,0,0)
vertices1[1] = Vector3.new(2,0,0)
vertices1[2] = Vector3.new(3,1,0)
vertices1[3] = Vector3.new(2,2,0)
vertices1[4] = Vector3.new(1,2,0)
vertices1[5] = Vector3.new(0,1,0)

vertices2 = Array.new(6)
vertices2[0] = Vector3.new(1,0,2)
vertices2[1] = Vector3.new(2,0,3)
vertices2[2] = Vector3.new(3,1,4)
vertices2[3] = Vector3.new(2,2,3)
vertices2[4] = Vector3.new(1,2,2)
vertices2[5] = Vector3.new(0,1,1)
geoms_polyline = [Polyline.new(vertices1, true), Polyline.new(vertices2, false)]
nodes.push( Disp3D::NodePolylines.new(geoms_polyline) )
nodes[1].material_color = [1,1,0,1]

main_view.world_scene_graph.add(nodes)
main_view.start

