require 'helper'

class NodeRectangleTestCase < Minitest::Test
  def setup
    # gl initalized befor creating node
   @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    geom = GMath3D::Rectangle.new()
    node_with_name = Disp3D::NodeRectangle.new(geom, :test)
    assert_equal(:test, node_with_name.name)

    node_without_name = Disp3D::NodeRectangle.new(geom)
    assert_equal(nil, node_without_name.name)

    geom_ary = [geom, GMath3D::Rectangle.new(Vector3.new(0,0,-1), Vector3.new(0,1,0),Vector3.new(1,0,0))]

    # invalid arg
    assert_raises ArgumentError do
      dmy = Disp3D::NodeRectangle.new(Vector3.new())
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeRectangle.new(geom_ary)
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeRectangle.new(geom, Vector3.new())
    end
  end

  #TODO texture test
end
