$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

box_geom = Box.new(Vector3.new(-1,-1,-1),Vector3.new(1,1,1))
box_tri_mesh_geom = TriMesh.from_box(box_geom)

main_view.world_scene_graph.open do
  create :type => :Tris,
         :geom => box_tri_mesh_geom,
         :name => :cube0,
         :normal_mode => Disp3D::NodeTris::NORMAL_EACH_FACE

  add :cube0

  add_new :name => :group0, :post_translate => Vector3.new(-2,-2,-2) do
    add :cube0
  end

  add_new :name => :group1, :post_translate => Vector3.new(2,-2,-2) do
    add :cube0
  end

  add_new :name => :group2, :post_translate => Vector3.new(2,2,-2) do
    add :cube0
  end

  add_new :name => :group3, :post_translate => Vector3.new(-2,2,-2) do
    add :cube0
  end
end

main_view.picker.post_picked do |results|
  if(results != nil)
    picked_node_name = nil
    puts "hit #{results.size} elements"
    results.each_with_index do | result, idx |
      puts "====element #{idx}===="
      puts "node name : #{result.node_path_info[0].node.name}"
      puts "instance id : #{result.node_path_info[0].node.instance_id}"
      puts "path id : #{result.node_path_info[0].path_id}"
      puts "=================="
      picked_node_name = result.node_path_info[0].node.name
    end
    if(!picked_node_name.nil?)
      main_view.world_scene_graph.open do
        update :name => picked_node_name,
               :material_color => [0,1,0,1]
      end
      main_view.update
    end
  end
end


main_view.mouse_press do |view, button, x, y|
  next if( button != GLUT::LEFT_BUTTON )
  view.picker.start_point_pick
end

main_view.start
