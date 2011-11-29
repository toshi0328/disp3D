$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

root_node = Disp3D::NodeCollection.new()

#=========================
# point and points
point_geom = Vector3.new(1,0,0)
point_node = Disp3D::NodePoints.new(point_geom)
point_node.colors = [0,1,0,1]
point_node.size = 7
root_node.add(point_node)

point_geoms = [Vector3.new(0,1,0), Vector3.new(1,1,0), Vector3.new(2,1,0)]
point_nodes = Disp3D::NodePoints.new(point_geoms)
point_nodes.material_color = [0,0,1,1]
point_nodes.size = 5
root_node.add(point_nodes)

#=========================
# line and lines
line_geom = FiniteLine.new(Vector3.new(0,0,1), Vector3.new(3,0,1))
line_node = Disp3D::NodeLines.new(line_geom)
line_node.width = 4
root_node.add(line_node)

line_geoms = Array.new()
[45, 90, 135].each do |angle|
  axis = Vector3.new(0,1,0)
  angle_rad = angle*Math::PI/180.0
  rot_mat = Matrix.from_axis(axis, angle_rad)
  line_geoms.push(line_geom.rotate(rot_mat))
end

line_nodes = Disp3D::NodeLines.new(line_geoms)
line_nodes.width = 2
line_nodes.colors = [1,1,0,1]
root_node.add(line_nodes)


#=========================
# polyline and polylines
polyline_geom_close = Polyline.new([Vector3.new(0,1,2), Vector3.new(1,1,2), Vector3.new(1,1.5,2), Vector3.new(1,1.5,3), Vector3.new(0,1.5,2)], false)
polyline_node = Disp3D::NodePolylines.new(polyline_geom_close)
polyline_node.width = 2
root_node.add(polyline_node)

#=========================
# text
str = "This is a pen."
text_node = Disp3D::NodeText.new( Vector3.new(2,2,2), nil, str)
root_node.add(text_node)

#=========================
# arrow
arrow_geom = FiniteLine.new(Vector3.new(0,3,1), Vector3.new(3,3,1))
arrow_node = Disp3D::NodeArrows.new(arrow_geom)
arrow_node.width = 4
arrow_node.colors = [1,0,0.5,1.0]
root_node.add(arrow_node)

arrow_geoms = Array.new()
[45, 90, 135].each do |angle|
  axis = Vector3.new(0,1,0)
  angle_rad = angle*Math::PI/180.0
  rot_mat = Matrix.from_axis(axis, angle_rad)
  arrow_geoms.push(arrow_geom.rotate(rot_mat))
end

arrow_nodes = Disp3D::NodeArrows.new(arrow_geoms)
arrow_nodes.width = 2
arrow_nodes.colors = [1,0.5,0.5,1]
root_node.add(arrow_nodes)

#=========================
# coordinate
coord_node = Disp3D::NodeCoord.new(Vector3.new(), 3)
root_node.add(coord_node)

#=========================
# work_plane
plane_geom = Plane.new(Vector3.new(0,0,-2), Vector3.new(0,1,0))
work_plane = Disp3D::NodeWorkplane.new(plane_geom)
work_plane.material_color = [1,0,0,0.5]
root_node.add(work_plane)


#=========================
# tris

#==========================
# circular reference
=begin
node_collection1 = NodeCollection.new()
node_collection2 = NodeCollection.new()
node_collection3 = NodeCollection.new()
node_collection1.add(node_collection2)
node_collection2.add(node_collection3)
node_collection3.add(node_collection1)
root_node.add(node_collection1)
=end
#=========================
main_view.world_scene_graph.add(root_node)


#=========================
# points on camera_scene_graph
point_geom_camera = Vector3.new(-300, 200, 0)
str_point = "[#{point_geom_camera}] on camera scene"
text_node_camera = Disp3D::NodeText.new( point_geom_camera, nil, str_point )
main_view.camera_scene_graph.add(text_node_camera)

point_node_camera = Disp3D::NodePoints.new(point_geom_camera)
point_node_camera.colors = [0,1,0,1]
point_node_camera.size = 7
main_view.camera_scene_graph.add(point_node_camera)


#=========================
# mouse procedure

# show picked node info when mouse button pressed
main_view.set_mouse_press Proc.new{|view, button, x, y|
  current_picker = view.picker
  if (current_picker != nil)
    result = current_picker.pick(x,y)
    if(result != nil && result.size > 0)
      p "hit #{result.size} elements"
      result.each do | item |
        p item
      end
    end
  end
}

main_view.start
