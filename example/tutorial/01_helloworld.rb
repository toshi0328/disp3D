$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

tea_pod_size = 10.0
main_view = Disp3D::GLUTWindow.new(400,400)
node_tea_pod = Disp3D::NodeTeaPod.new(tea_pod_size)
node_tea_pod.material_color = [1,1,0,1]
main_view.world_scene_graph.add(node_tea_pod)

main_view.camera.is_orth = true
main_view.start

