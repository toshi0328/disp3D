$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400,"03_CameraScene")

box1 = TriMesh.from_box(Box.new(Vector3.new(-1,-1,-1),Vector3.new(1,1,1)))
box2 = TriMesh.from_box(Box.new(Vector3.new(-200,-100,0),Vector3.new(-150,-50,0.5)))

main_view.world_scene_graph.open do
  add_new :type => :Tris,
          :geom => box1,
          :material_color => [1,0,0,1],
          :normal_mode => Disp3D::NodeTris::NORMAL_EACH_FACE
end

main_view.camera_scene_graph.open do
  add_new :type => :Tris,
          :geom => box2,
          :colors => [0,1,0,1]
end

main_view.start
