$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

main_view = Disp3D::View.new(100,100,200,200)
main_view.world_scene_graph.add(Disp3D::NodeTeaPod.new())
main_view.start

