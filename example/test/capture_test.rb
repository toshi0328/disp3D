$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(400,300)
node_tea_pod = Disp3D::NodeTeaPod.new(5)
node_tea_pod.material_color = [1,1,0,1]
main_view.world_scene_graph.add(node_tea_pod)
main_view.camera.is_orth = true
main_view.fit
angle = 30.0/180.0*Math::PI
main_view.camera.rotate = Quat.from_axis(Vector3.new(1,0.5,0.0).normalize, angle)

image = main_view.capture
image.write File.dirname(__FILE__) + '/data/captured.png'

main_view.start
