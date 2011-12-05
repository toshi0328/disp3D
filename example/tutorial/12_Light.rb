$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(400,400,"12_Light")

light_pos_ary = [Vector3.new(30,0,0), Vector3.new(-30,0,0), Vector3.new(0,0,30), Vector3.new(0,5,0)]
light_spot_dir_ary = [Vector3.new(-1,0,0), Vector3.new(1,0,0), Vector3.new(0,0,-1), Vector3.new(0,-1,0)]

main_view.world_scene_graph.open do
  add_new :type => :TeaPod,
          :name => :pod,
          :material_color => [1,1,1,1],
          :size => 10.0

  add_new :type => :Workplane,
          :name => :workplane,
          :geom => Plane.new(Vector3.new(0,-8,0), Vector3.new(0,1,0)),
          :material_color => [0.8,0.8,0.2,0.5],
          :grid => 10

  light_pos_ary.each_with_index do |light_pos,idx|
    add_new :type => :Sphere,
            :name => :lightSource,
            :radius => 1.0,
            :center => light_pos
  end
end

main_view.light.open do
  set :id => 0,
      :enable => true,
      :diffuse => [0, 0.7, 0, 1],
      :ambient => [0, 0.2, 0, 1],
      :specular => [0, 1, 0, 1],
      :position => light_pos_ary[0],
      :spot_direction => light_spot_dir_ary[0]

  set :id => 1,
      :enable => true,
      :diffuse => [0.7, 0, 0, 1],
      :ambient => [0.2, 0, 0, 1],
      :specular => [1, 0, 0, 1],
      :position => light_pos_ary[1],
      :spot_direction => light_spot_dir_ary[1]

  set :id => 2,
      :enable => true,
      :diffuse => [0, 0, 0.7, 1],
      :ambient => [0, 0, 0.2, 1],
      :specular => [0, 0, 1, 1],
      :position => light_pos_ary[2],
      :spot_direction => light_spot_dir_ary[2]

  set :id => 3,
      :enable => true,
      :diffuse => [0.7, 0.7, 0.7, 1],
      :ambient => [0.2, 0.2, 0.2, 1],
      :specular => [1, 1, 1, 1],
      :position => light_pos_ary[3],
      :spot_direction => light_spot_dir_ary[3]
end

main_view.camera.projection = Disp3D::Camera::ORTHOGONAL
main_view.start

