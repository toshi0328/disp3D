$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

main_view = Disp3D::View.new(100,100,200,200)

nodes = []

geom1 = [GMath3D::Vector3.new(-1,0,0),
        GMath3D::Vector3.new( 0,0,0),
        GMath3D::Vector3.new( 1,0,0)]
nodes.push( Disp3D::NodePoints.new(geom1) )

geom2 = GMath3D::Vector3.new(1,0,0)
node1 = Disp3D::NodePoints.new(geom2)
node2 = Disp3D::NodePoints.new(geom2)
node3 = Disp3D::NodePoints.new(geom2)

node1.translate = [ 0,0.5,0]
node2.translate = [-1,0.5,0]
node3.translate = [-2,0.5,0]
nodes.push( node1 )
nodes.push( node2 )
nodes.push( node3 )

main_view.world_scene_graph.add(nodes)

main_view.start
