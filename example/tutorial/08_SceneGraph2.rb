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

main_view.mouse_press do |view, button, x, y|
  results = view.picker.pick(x,y)
  if(results != nil)
    # remove node path when left button pressed
    if( button == GLUT::LEFT_BUTTON )
      path_id_ary = results.collect {| result | result.node_path_info[0].path_id }
      main_view.world_scene_graph.open do
        path_id_ary.each do |path_id|
          remove path_id
        end
      end
      main_view.update
    end

    # delete node when right button pressed
    if( button == GLUT::RIGHT_BUTTON )
      main_view.world_scene_graph.open do
        delete :cube0
      end
      main_view.update
    end
  end
end

main_view.start
