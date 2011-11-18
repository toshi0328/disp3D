$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(400,400)
node_tea_pod = Disp3D::NodeTeaPod.new(nil)
node_tea_pod.material_color = [1,1,0,1]
main_view.world_scene_graph.add(node_tea_pod)

plane = Plane.new(Vector3.new(0, -0.38, 0), Vector3.new(0,1,0))
node_workplane = Disp3D::NodeWorkplane.new(plane)
node_workplane.colors = [1,0,0,0.5]

main_view.world_scene_graph.add(node_workplane)
main_view.camera.is_orth = true
main_view.start

