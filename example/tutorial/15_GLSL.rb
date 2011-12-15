$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

vert_file = File.dirname(__FILE__) + '/GLSL/simple.vert'
frag_file = File.dirname(__FILE__) + '/GLSL/simple.frag'

main_view = Disp3D::GLUTWindow.new(400,400, "15_GLSL", vert_file, frag_file)
main_view.world_scene_graph.open do
  add_new :type => :TeaPod,
          :size => 10.0
end
main_view.camera.projection = Disp3D::Camera::ORTHOGONAL
main_view.start
