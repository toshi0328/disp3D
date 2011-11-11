$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

require 'gmath3D'

MiniTest::Unit.autorun

class CameraTestCase < MiniTest::Unit::TestCase
  def setup
    gl_view = Disp3D::GLUTWindow.new(400, 300)
    @camera = gl_view.camera
    line_geom = GMath3D::FiniteLine.new(GMath3D::Vector3.new(0,0,0), GMath3D::Vector3.new(1,1,1))
    line_node = Disp3D::NodeLines.new(line_geom)
    line_node.width = 4
    gl_view.world_scene_graph.add(line_node)
  end

  def test_get_view_port
    viewport = @camera.viewport
    assert_equal(0, viewport[0])
    assert_equal(0, viewport[1])
    assert_equal(400, viewport[2])
    assert_equal(300, viewport[3])
  end

  def test_fit
    rad = 10.0
    @camera.fit(rad)
    assert_in_delta(62.20084679281463, @camera.eye.z, 1e-8)
    assert_in_delta(1.0, @camera.scale, 1e-8)
    assert_in_delta(82.20084679281463, @camera.far, 1e-8)
    assert_in_delta(1.0, @camera.scale, 1e-8)

    @camera.is_orth = true
    @camera.fit(rad)
    assert_in_delta(62.20084679281463, @camera.eye.z, 1e-8)
    assert_in_delta(82.20084679281463, @camera.far, 1e-8)
    assert_in_delta(15.0, @camera.scale, 1e-8)
  end

end
