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

#=========================
# coordinate
coord_node = NodeCoord.new(Vector3.new(), 3)
main_view.world_scene_graph.add(coord_node)

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

main_view.start
