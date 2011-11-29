$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(400,400, "01_HelloWorld")
main_view.world_scene_graph.open do
  add_new :type => :TeaPod,
          :material_color => [1,1,0,1],
          :size => 10.0
end
main_view.camera.projection = Disp3D::Camera::ORTHOGONAL
main_view.start
