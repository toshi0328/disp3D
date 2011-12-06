$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(400,400,"13_RectPick")

sphere_count = 20
main_view.world_scene_graph.open do
  idx = 0
  sphere_count.times.each do |idx_x|
    sphere_count.times.each do |idx_y|
      add_new :type => :Sphere,
              :center => Vector3.new(idx_x*5, idx_y*5, 0),
              :name => "node_#{idx}".to_sym
      idx += 1
    end
  end
end

main_view.picker.start_rect_pick do |results|
  if(results != nil)
    results.each do |result|
      result.node_path_info.each do |path_info|
        main_view.world_scene_graph.open do
          update :name => path_info.node.name,
                 :material_color => [1,0,0,1]
        end
      end
    end
    main_view.update
  end
end

main_view.camera.projection = Disp3D::Camera::ORTHOGONAL
main_view.fit
main_view.start


