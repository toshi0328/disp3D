require 'helper'

class NodeArrowsTestCase < Minitest::Test
  def setup
    # gl initalized befor creating node
   @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    geom = GMath3D::FiniteLine.new(Vector3.new(0,0,0),Vector3.new(1,0,0))
    geom_ary = [geom, GMath3D::FiniteLine.new(Vector3.new(0,0,1),Vector3.new(1,0,1))]
    node_with_name = Disp3D::NodeArrows.new(geom, :test_array)

    node_without_name = Disp3D::NodeArrows.new(geom_ary)
    node_without_name.width = 2.0

    assert_equal(:test_array, node_with_name.name)
    assert_equal(1.0, node_with_name.width)

    assert_equal(:test_array, node_with_name.name)
    assert_equal(2.0, node_without_name.width)

    # invalid arg
    assert_raises ArgumentError do
      dmy = Disp3D::NodeArrows.new(Vector3.new())
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeArrows.new([Vector3.new(), Vector3.new(1,0,0)])
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeArrows.new(geom_ary, Vector3.new())
    end
  end

end
