$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

rect_geom = Rectangle.new(Vector3.new(-1,-1,2), Vector3.new(2,0,0), Vector3.new(0,2,0))
box_geom = Box.new(Vector3.new(),Vector3.new(1,1,1))
box_tri_mesh_geom = TriMesh.from_box(box_geom)

main_view.world_scene_graph.open do
  # plane
  add_new :type => :Rectangle,
          :geom => rect_geom,
          :name => :rectangle0

  # text
  rect_geom.vertices.each do | vertex |
    add_new :type => :Text,
            :geom => vertex,
            :text => vertex.to_element_s,
            :colors => [1,0,0,1]
  end

  #cubes
  add_new :type => :Tris,
          :geom => box_tri_mesh_geom,
          :normal_mode => Disp3D::NodeTris::NORMAL_EACH_FACE,
          :material_color => [1,0,0,1],
          :post_translate => Vector3.new(-2,-2,0),
          :name => :cube0

  add_new :type => :Tris,
          :geom => box_tri_mesh_geom,
          :normal_mode => Disp3D::NodeTris::NORMAL_EACH_FACE,
          :material_color => [0,1,0,1],
          :post_translate => Vector3.new(1,-2,0),
          :name => :cube1

  add_new :type => :Tris,
          :geom => box_tri_mesh_geom,
          :normal_mode => Disp3D::NodeTris::NORMAL_EACH_FACE,
          :material_color => [0,0,1,1],
          :post_translate => Vector3.new(1,1,0),
          :name => :cube2

  add_new :type => :Tris,
          :geom => box_tri_mesh_geom,
          :normal_mode => Disp3D::NodeTris::NORMAL_EACH_FACE,
          :material_color => [0,0,0,1],
          :post_translate => Vector3.new(-2,1,0),
          :name => :cube3
end

main_view.mouse_press do |view, button, x, y|
  next if( button != GLUT::LEFT_BUTTON )
  # result is Array of PickedResult
  results = view.picker.pick(x,y)
  if(results != nil)
    puts "hit #{results.size} elements"
    results.each_with_index do | result, idx |
      puts "====element #{idx}===="
      puts "world position : #{result.world_position}"
      puts "node name : #{result.node_path_info[0].node.name}"
      puts "color : #{result.node_path_info[0].node.material_color}"
      puts "instance id : #{result.node_path_info[0].node.instance_id}"
      puts "path id : #{result.node_path_info[0].path_id}"
      puts "=================="
    end
  end
end

main_view.start
