$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

file_path = File.dirname(__FILE__) + "./data/bunny.stl";
if( !File.exists?(file_path) )
  puts file_path + " is not exist!"
  exit
end

main_view = Disp3D::GLUTWindow.new(600,400)

stl = Disp3D::STL.new()
stl.parse(file_path, Disp3D::STL::ASCII)

main_view.world_scene_graph.open do
  add_new :type => :Tris,
          :geom => stl
end

main_view.start
