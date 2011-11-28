$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

Disp3D::Node.create_group :root_node do |n|
  n.add_point :geom => Vector3.new(0,0,0), :colors => [1,0,0,1], :size => 7
=begin
  point :geom => Vector3.new(1,0,0), :colors => [0,1,0,1], :size => 4
  point :geom => Vector3.new(2,0,0), :colors => [0,0,1,1], :size => 2
  group :sub_node do
  end
=end
end

#main_view.world_scene_graph.add(:root_node)
#main_view.start
