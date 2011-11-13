$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

require 'gmath3D'

MiniTest::Unit.autorun

class GLViewTestCase < MiniTest::Unit::TestCase
  def setup
    @gl_view_has_line = Disp3D::GLUTWindow.new(300, 300)
    line_geom = GMath3D::FiniteLine.new(GMath3D::Vector3.new(0,0,0), GMath3D::Vector3.new(1,1,1))
    line_node = Disp3D::NodeLines.new(line_geom)
    line_node.width = 4
    @gl_view_has_line.world_scene_graph.add(line_node)

    @gl_view_has_point = Disp3D::GLUTWindow.new(300, 300)
    point_geom = GMath3D::Vector3.new(3,2,1)
    point_node = Disp3D::NodePoints.new(point_geom)
    point_node.size = 4
    @gl_view_has_point.world_scene_graph.add(point_node)
  end

  def test_center_pos
    center_pos = @gl_view_has_line.center_pos
    assert_equal(Vector3.new(0.5, 0.5, 0.5), center_pos)

    center_pos = @gl_view_has_point.center_pos
    assert_equal(Vector3.new(3,2,1), center_pos)
  end

  def test_bb_radius
    radius = @gl_view_has_line.bb_radius
    assert_in_delta(0.5*Math.sqrt(3.0), radius, 1.0e-8)

    radius = @gl_view_has_point.bb_radius
    assert_equal(0.0, radius)
  end
end
