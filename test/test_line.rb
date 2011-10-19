$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

main_view = Disp3D::View.new(100,100,200,200)
line_geom = GMath3D::FiniteLine.new()
line_node = Disp3D::NodeLines.new(line_geom)
main_view.world_scene_graph.add(line_node)
main_view.start
