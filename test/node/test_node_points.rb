$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'helper'

MiniTest::Unit.autorun

class NodePointsTestCase < MiniTest::Unit::TestCase
  def setup
    # gl initalized befor creating node
   @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    geom = Vector3.new(0,0,0)
    geom_ary = [geom, Vector3.new(0,0,1)]
    node_with_name = Disp3D::NodePoints.new(geom, :test_array)

    node_without_name = Disp3D::NodePoints.new(geom_ary)
    node_without_name.size = 1.0

    assert_equal(:test_array, node_with_name.name)
    assert_equal(2.0, node_with_name.size)

    assert_equal(:test_array, node_with_name.name)
    assert_equal(1.0, node_without_name.size)

    # invalid arg
    assert_raises ArgumentError do
      dmy = Disp3D::NodePoints.new(Box.new())
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodePoints.new([Box.new(), Vector3.new(1,0,0)])
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodePoints.new(geom_ary, Vector3.new())
    end
  end

end
