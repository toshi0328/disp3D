$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

require 'gmath3D'

MiniTest::Unit.autorun

class ManipulatorTestCase < MiniTest::Unit::TestCase
  def setup
    # GL must be initialized...
    @gl_view_has_line = Disp3D::GLUTWindow.new(300, 300)

    line_geom = GMath3D::FiniteLine.new(GMath3D::Vector3.new(0,0,0), GMath3D::Vector3.new(1,1,1))
    line_node = Disp3D::NodeLines.new(line_geom)
    @scene_graph_having_line = Disp3D::SceneGraph.new()
    @scene_graph_having_line.add(line_node)

    point_geom = GMath3D::Vector3.new(3,2,1)
    point_node = Disp3D::NodePoints.new(point_geom)
    @scene_graph_having_point = Disp3D::SceneGraph.new()
    @scene_graph_having_point.add(point_node)
  end

  def test_center_pos
    center_pos = @scene_graph_having_line.center
    assert_equal(Vector3.new(0.5, 0.5, 0.5), center_pos)

    center_pos = @scene_graph_having_point.center
    assert_equal(Vector3.new(3,2,1), center_pos)
  end

  def test_bb_radius
    radius = @scene_graph_having_line.radius
    assert_in_delta(0.5*Math.sqrt(3.0), radius, 1.0e-8)

    radius = @scene_graph_having_point.radius
    assert_equal(0.0, radius)
  end
end
