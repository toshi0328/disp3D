$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

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

  def test_fit
    assert_equal( Vector3.new(0,0,0), @gl_view_has_line.camera.post_translate)
    assert_equal( 1.0, @gl_view_has_line.camera.scale)
    assert_equal( 1.0, @gl_view_has_line.camera.eye.z)
    @gl_view_has_line.fit
    assert_equal( Vector3.new(-0.5,-0.5,-0.5), @gl_view_has_line.camera.post_translate)
    assert_equal( 1.0, @gl_view_has_line.camera.scale)
    assert_in_delta( 1.0, @gl_view_has_line.camera.eye.z, 4.57081, 1e-3)
  end

  def test_centering
    assert_equal( Vector3.new(0,0,0), @gl_view_has_line.camera.post_translate)
    @gl_view_has_line.centering
    assert_equal( Vector3.new(-0.5,-0.5,-0.5), @gl_view_has_line.camera.post_translate)
  end

end
