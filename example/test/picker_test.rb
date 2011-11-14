$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

include GMath3D
include Disp3D

main_view = GLUTWindow.new(600,400)


#=========================
# point and points
point_geom = Vector3.new(0,0,0)
point_node = NodePoints.new(point_geom)
point_node.colors = [0,1,0,1]
point_node.size = 9

main_view.world_scene_graph.add(point_node)

point_geom2 = Vector3.new(0,1,0)
point_node2 = NodePoints.new(point_geom2)
point_node2.colors = [0,1,1,1]
point_node2.size = 9

main_view.world_scene_graph.add(point_node2)

#=========================
# coordinate
#coord_node = NodeCoord.new(Vector3.new(), 3)
#main_view.world_scene_graph.add(coord_node)

#=========================
# plane
rect_geom = Rectangle.new(Vector3.new(-1,-1,2), Vector3.new(2,0,0), Vector3.new(0,2,0))
rect_node = NodeTris.new(TriMesh.from_rectangle(rect_geom))
main_view.world_scene_graph.add(rect_node)

#=========================
# text
vertices = rect_geom.vertices
vertices.each do | vertex |
  text_node = NodeText.new(vertex.to_element_s, vertex)
  text_node.colors = [1,0,0,1]
  main_view.world_scene_graph.add(text_node)
end

#=========================
# mouse procedure
# show picked node info when mouse button pressed
main_view.set_mouse_press Proc.new{|view, button, x, y|
  current_picker = view.picker
  if (current_picker != nil)
    result = current_picker.hit_test(x,y)
    if(result != nil && result.size > 0)
      p "hit #{result.size} elements"
      result.each do | item |
        p item
      end
    end
  end
}

main_view.camera.is_orth = true
main_view.manipulator.set_rotation_ceter(Vector3.new(1,1,2))
main_view.start
