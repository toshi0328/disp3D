$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)
root_node = Disp3D::NodeCollection.new()

stl = Disp3D::STL.new();
file_path = File.dirname(__FILE__) + "/../../test/data/bunny.stl";

if( !File.exists?(file_path) )
  p file_path + " is not exist!"
  exit
end
stl.parse(file_path, Disp3D::STL::ASCII)
stl_node = Disp3D::NodeTris.new( stl.tri_mesh )

main_view.world_scene_graph.add(stl_node)
#main_view.camera.is_orth = true
main_view.start
