$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(400,400,"14_LineRubberband")

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

main_view.picker.post_picked do |start_results, end_results|
  if(!start_results.nil? && start_results.size > 0 && !end_results.nil? && end_results.size >0)
    start_point = start_results[0].world_position
    end_point = end_results[0].world_position
    main_view.world_scene_graph.open do
      add_new :type => :Lines,
              :geom => FiniteLine.new(start_point, end_point),
              :colors => [1,0,0,1]
    end
    main_view.update
  end
  main_view.picker.end_pick
end

main_view.mouse_press do |view, button, x, y|
  next if( button != GLUT::LEFT_BUTTON )
  results = main_view.picker.point_pick(x,y)
  if(results != nil && results.size > 0)
    main_view.picker.start_line_pick
  end
end

main_view.camera.projection = Disp3D::Camera::ORTHOGONAL
main_view.fit
main_view.start
