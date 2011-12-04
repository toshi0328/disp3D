$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(400,400,"10_Animation")

light_pos_ary = [Vector3.new(30,0,0), Vector3.new(-30,0,0)]

main_view.world_scene_graph.open do
  add_new :type => :TeaPod,
          :material_color => [1,1,1,1],
          :size => 10.0,
          :name => :pod

  light_pos_ary.each_with_index do |light_pos,idx|
    add_new :type => :Cone,
            :name => :lightSource,
            :post_translate => light_pos
  end
end

main_view.light.open do
  set :id => 0,
      :enable => true,
      :diffuse => [0.7, 0, 0, 1],
      :ambient => [0.2, 0, 0, 1],
      :specular => [1, 0, 0, 1],
      :position => light_pos_ary[0]

  set :id => 1,
      :enable => true,
      :diffuse => [0, 0.7, 0, 1],
      :ambient => [0, 0.2, 0, 1],
      :specular => [0, 1, 0, 1],
      :position => light_pos_ary[1]
end

main_view.camera.projection = Disp3D::Camera::ORTHOGONAL
main_view.start

