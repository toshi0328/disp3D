$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

include GMath3D

main_view = Disp3D::View.new(100,100,200,200)

geom = TriMesh.from_box( Box.new(Vector3.new(-0.5,-0.5,-0.5), Vector3.new(0.5,0.5,0.5)))
node = Disp3D::NodeTris.new(geom)
node.color = [1,0,0]
main_view.world_scene_graph.add(node)

main_view.start
