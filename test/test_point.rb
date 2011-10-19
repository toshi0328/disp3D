$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

main_view = Disp3D::View.new(100,100,200,200)

geom1 = GMath3D::Vector3.new(-1,0,0)
node1 = Disp3D::NodePoints.new(geom1)
node1.color = [1,1,1]
main_view.world_scene_graph.add(node1)

geom2 = GMath3D::Vector3.new(0,0,0)
node2 = Disp3D::NodePoints.new(geom2)
node2.color = [0,1,1]
node2.size = 6
main_view.world_scene_graph.add(node2)

geom3 = GMath3D::Vector3.new(1,0,0)
node3 = Disp3D::NodePoints.new(geom3)
node3.color = [1,0,0]
node3.size = 9
main_view.world_scene_graph.add(node3)



main_view.start
