$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

#=========================
# load image
file_path1 = File.dirname(__FILE__) + '/data/test.png'
image1 = Magick::Image.read(file_path1).first

#=========================
# rect
original_point = Vector3.new(0,0,0)
length = 100
rect_geom1 = Rectangle.new(original_point, Vector3.new(length,0,0), Vector3.new(0,length,0))
rect_node1 = Disp3D::NodeRectangle.new(rect_geom1, image1)
main_view.world_scene_graph.add(rect_node1)

#=========================
# load image
file_path2 = File.dirname(__FILE__) + '/data/test2.jpg'
image2 = Magick::Image.read(file_path2).first

#=========================
# rect
original_point = Vector3.new(200,0,0)
rect_geom2 = Rectangle.new(original_point, Vector3.new(length,0,0), Vector3.new(0,length,0))
rect_node2 = Disp3D::NodeRectangle.new(rect_geom2, image2)
main_view.world_scene_graph.add(rect_node2)

#=========================
# rectplane
original_point = Vector3.new(-200,0,0)
rect_geom3 = Rectangle.new(original_point, Vector3.new(length,0,0), Vector3.new(0,length,0))
rect_node3 = Disp3D::NodeRectangle.new(rect_geom3)
main_view.world_scene_graph.add(rect_node3)

bb = main_view.world_scene_graph.bounding_box
p main_view.world_scene_graph.radius
main_view.fit
p main_view.camera.obj_rep_length
main_view.start
