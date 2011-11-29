$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400,"02_Elements")

main_view.world_scene_graph.open do
  # point
  add_new :type => :Points,
          :geom => Vector3.new(0,0,0),
          :colors => [1,0,0,1],
          :size => 5

  # point array
  add_new :type => :Points,
          :geom => [Vector3.new(-1,0,0), Vector3.new(1,0,0)],
          :colors => [0,1,0,1],
          :size => 3

  # line
  add_new :type => :Lines,
          :geom => FiniteLine.new(Vector3.new(-1,0,0.5), Vector3.new(1,0,0.5)),
          :colors => [1,0,0,1],
          :width => 5

  # line ary
  base_line_geom = FiniteLine.new(Vector3.new(0,0,0.5), Vector3.new(1,0,0.5))
  line_geom_ary = Array.new
  [45, 90, 135].each do |angle|
    rotate_matrix = Matrix.from_axis(Vector3.new(0,0,1), angle*Math::PI/180.0)
    line_geom_ary.push(base_line_geom.rotate(rotate_matrix))
  end
  add_new :type => :Lines,
          :geom => line_geom_ary,
          :colors => [0,1,0,1],
          :width => 3

  # text
  add_new :type => :Text,
          :geom => Vector3.new(0,0,1),
          :colors => [1,0,0,1],
          :text => "Test Text"

  # arrow
  add_new :type => :Arrows,
          :geom => FiniteLine.new(Vector3.new(-1,0,1.5), Vector3.new(1,0,1.5)),
          :colors => [1,0,1,1],
          :width => 4

  # arrow ary
  base_arrow_geom = FiniteLine.new(Vector3.new(0,0,1.5), Vector3.new(1,0,1.5))
  arrow_geom_ary = Array.new
  [45, 90, 135].each do |angle|
    rotate_matrix = Matrix.from_axis(Vector3.new(0,0,1), angle*Math::PI/180.0)
    arrow_geom_ary.push(base_arrow_geom.rotate(rotate_matrix))
  end
  add_new :type => :Arrows,
          :geom => arrow_geom_ary,
          :colors => [0,1,1,1],
          :width => 2

  # polyline
  add_new :type => :Polylines,
          :geom => Polyline.new([Vector3.new(-1,0,2), Vector3.new(1,0,2), Vector3.new(1,0,2.3), Vector3.new(-1,0,2.3)]),
          :colors => [1,0,0,1],
          :width => 3

=begin
  # polyline ary
  base_polyline_geom = Polyline.new([Vector3.new(0,0,2), Vector3.new(1,0,2), Vector3.new(1,0,2.3), Vector3.new(0,0,2.3)]),
  polyline_geom_ary = Array.new
  [45, 90, 135].each do |angle|
    rotate_matrix = Matrix.from_axis(Vector3.new(0,0,1), angle*Math::PI/180.0)
    polyline_geom_ary.push(base_polyline_geom.rotate(rotate_matrix))
  end
  add_new :type => :Polylines,
          :geom => polyline_geom_ary,
          :colors => [0,1,1,1],
          :width => 2
=end
end

main_view.start
