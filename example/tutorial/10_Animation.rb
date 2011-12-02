$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

main_view.world_scene_graph.open do
  add_new :type => :TeaPod,
          :material_color => [1,1,0,1],
          :size => 10.0,
          :name => :pod
end

main_view.idle_process 100 do
  node = Disp3D::NodeDB.find_by_name(:pod)
  if(!node.nil?)
    rot_quat = Quat::from_axis(Vector3.new(0,1,0), 10.0/180.0*Math::PI)
    if(node.rotate.nil?)
      node.rotate = rot_quat
    else
      node.rotate += rot_quat
    end
  end
  main_view.update
end
main_view.camera.projection = Disp3D::Camera::ORTHOGONAL
main_view.start

