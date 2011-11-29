$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

Disp3D::NodeCollection.create :root_node do
  add_new :type => :Points,
          :geom => Vector3.new(0,0,0),
          :size => 5

  add_new :type => :Lines,
          :name => :line1,
          :geom => FiniteLine.new(Vector3.new(-1, 1, 0),Vector3.new(1, 1, 0)),
          :colors => [1,1,0,1],
          :width => 3

  add_new :sub_node do
    transform :pre_translate => Vector3.new(0,-1,0)
    add_new :type => :Points,
            :geom => Vector3.new(0,0,0),
            :colors => [1,0,0,1],
            :size => 3
  end
end

main_view.world_scene_graph.add(:root_node)
main_view.start
