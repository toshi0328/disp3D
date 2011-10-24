$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

main_view = Disp3D::GLUTWindow.new(400,400)
file_path = File.dirname(__FILE__) + "/test_data/cube-ascii.stl"
stl = Disp3D::STL.new()
stl.parse(file_path)
node = Disp3D::NodeTris.new(stl.tri_mesh)
node.color = [1,0,0,1]
main_view.world_scene_graph.add(node)
main_view.start

