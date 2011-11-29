$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

Disp3D::NodeCollection.create :root_node do
  add_new :type => :TeaPod,
          :material_color => [0,0,1,1],
          :post_translate => Vector3.new(0,0,-4),
          :size => 3

  add_new :type => :Points,
          :geom => Vector3.new(0,0,0),
          :colors => [1,1,0,1],
          :size => 5

  add_new :type => :Lines,
          :name => :line1,
          :geom => FiniteLine.new(Vector3.new(-1, 1, 0),Vector3.new(1, 1, 0)),
          :width => 3

  add_new :sub_node do
    transform :pre_translate => Vector3.new(0,0,-1)
    add_new :type => :Points,
            :geom => Vector3.new(0,0,0),
            :colors => [1,0,0,1],
            :size => 3

    add :line1
  end

  # "add_new" is as same as "create" and "add" process

  create :type => :Polylines,
         :name => :polyline1,
         :geom => Polyline.new([Vector3.new(-1,0,0), Vector3.new(1,0,0), Vector3.new(1,3,0)]),
         :colors => [0,1,0,1],
         :width => 4

  add :polyline1
end

main_view.world_scene_graph.add(:root_node)
main_view.start
