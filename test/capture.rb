$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

  main_view = Disp3D::GLUTWindow.new(400,400)
  node_tea_pod = Disp3D::NodeTeaPod.new(nil)
  node_tea_pod.material_color = [1,1,0,1]
  main_view.world_scene_graph.add(node_tea_pod)

  rectangle = GMath3D::Rectangle.new(Vector3.new(-1, -0.38, -1), Vector3.new(2,0,0), Vector3.new(0,0,2))
  rectangle_mesh = GMath3D::TriMesh.from_rectangle(rectangle)
  node_plane = Disp3D::NodeTris.new( rectangle_mesh )
  node_plane.colors = [1,0,0,0.5]

  main_view.world_scene_graph.add(node_plane)

  main_view.set_mouse_press Proc.new{|view, button, x, y|
    # capture
    image = view.capture
p image
    
    # exit
  exit
  }
p "start"
  main_view.start
p "done capture"

