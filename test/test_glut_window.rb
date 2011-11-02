$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

include GMath3D
include Disp3D

main_view = GLUTWindow.new(600,400)

root_node = NodeCollection.new()

#=========================
# point and points
point_geom = Vector3.new(1,0,0)
point_node = NodePoints.new(point_geom)
point_node.material_color = [0,1,0,1]
point_node.size = 7
root_node.add(point_node)

point_geoms = [Vector3.new(0,1,0), Vector3.new(1,1,0), Vector3.new(2,1,0)]
point_nodes = NodePoints.new(point_geoms)
point_nodes.material_color = [0,0,1,1]
point_nodes.size = 5
root_node.add(point_nodes)

#=========================
# line and lines
line_geom = FiniteLine.new(Vector3.new(0,0,1), Vector3.new(3,0,1))
line_node = NodeLines.new(line_geom)
line_node.width = 4
root_node.add(line_node)

line_geoms = Array.new()
[45, 90, 135].each do |angle|
  axis = Vector3.new(0,1,0)
  angle_rad = angle*Math::PI/180.0
  rot_mat = Matrix.from_axis(axis, angle_rad)
  line_geoms.push(line_geom.rotate(rot_mat))
end

line_nodes = NodeLines.new(line_geoms)
line_nodes.width = 2
line_nodes.material_color = [1,1,0,1]
root_node.add(line_nodes)


#=========================
# polyline and polylines
polyline_geom_close = Polyline.new([Vector3.new(0,1,2), Vector3.new(1,1,2), Vector3.new(1,1.5,2), Vector3.new(1,1.5,3), Vector3.new(0,1.5,2)], false)
polyline_node = NodePolylines.new(polyline_geom_close)
polyline_node.width = 2
root_node.add(polyline_node)

#=========================
# text
str = "This is a pen."
text_node = NodeText.new()
text_node.text = str
text_node.position = Vector3.new(2,2,2)
root_node.add(text_node)

#=========================
# plane



#=========================
# tris



#=========================
main_view.world_scene_graph.add(root_node)

#=========================
# mouse procedure

# show picked node info when mouse button pressed
main_view.set_mouse_press Proc.new{|view, button, x, y|
  current_picker = view.picker
  if (current_picker != nil)
    result = current_picker.hit_test(x,y)
    if(result != nil && result.size > 0)
      p "hit #{result.size} elements"
      p
      result.each do | item |
        p item
        p
      end
    end
  end
}

main_view.start
