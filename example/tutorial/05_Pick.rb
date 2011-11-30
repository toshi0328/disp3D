$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

include GMath3D
include Disp3D

main_view = GLUTWindow.new(600,400)

rect_geom = Rectangle.new(Vector3.new(-1,-1,2), Vector3.new(2,0,0), Vector3.new(0,2,0))
tri_mesh_geom = TriMesh.from_rectangle(rect_geom)

main_view.world_scene_graph.open do
  # plane
  add_new :type => :Tris,
          :geom => tri_mesh_geom

  # text
  rect_geom.vertices.each do | vertex |
    add_new :type => :Text,
            :geom => vertex,
            :text => vertex.to_element_s,
            :colors => [1,0,0,1]
  end
end

=begin
main_view.set_mouse_press Proc.new{|view, button, x, y|
  current_picker = view.picker
  if (current_picker != nil)
    result = current_picker.pick(x,y)
    if(result != nil && result.size > 0)
      p "hit #{result.size} elements"
      result.each do | item |
#        p item
      end
    end
  end
}
=end
main_view.start
