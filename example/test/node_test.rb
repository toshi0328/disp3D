$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

################
# cube instance
cube_geom = GMath3D::Box.new(Vector3.new(-1, -1, -1), Vector3.new(1, 1, 1))
cube_node = Disp3D::NodeTris.new(GMath3D::TriMesh.from_box(cube_geom))
cube_node.normal_mode = Disp3D::NodeTris::NORMAL_EACH_FACE

################
# group_node
group_nodes = Array.new()
4.times do |i|
  group_nodes[i] = Disp3D::NodeCollection.new()
  group_nodes[i].add(cube_node)
end
group_nodes[0].pre_translate = GMath3D::Vector3.new(-2,-3,0)
group_nodes[1].pre_translate = GMath3D::Vector3.new(2,-3,0)
group_nodes[2].pre_translate = GMath3D::Vector3.new(-2,3,0)
group_nodes[3].pre_translate = GMath3D::Vector3.new(2,4,0)

axis = GMath3D::Vector3.new(0,0,1)
angle = 30.0*Math::PI/180.0
group_nodes[2].rotate = GMath3D::Quat.from_axis(axis,angle)
group_nodes[3].rotate = GMath3D::Quat.from_axis(axis,angle)

group_nodes.each do |node|
  p node.box
end

################
# root_node
root_node = Disp3D::NodeCollection.new()
group_nodes.each do |group_node|
  root_node.add(group_node)
end

main_view.world_scene_graph.add(root_node)

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
        p "instance_id : #{item.node_path_info[0].node.instance_id}"
        p "path_id : #{item.node_path_info[0].path_id}"
        p "parent is nil? : #{item.node_path_info[0].parent_node.nil?}"
      end
    end
  end
}


main_view.start
