$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

main_view = Disp3D::GLUTWindow.new(400,400)
node = Disp3D::NodeTeaPod.new(nil)
node.color = [1,0,0]
main_view.world_scene_graph.add(node)
main_view.start

