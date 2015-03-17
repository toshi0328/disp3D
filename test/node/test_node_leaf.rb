require 'helper'

class NodeLeafTestCase < Minitest::Test
  def setup
    # gl initalized befor creating node
    @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    node_with_name = Disp3D::NodeLeaf.new(GMath3D::Geom.new(), :test_array)

    assert_equal([1,1,1,1], node_with_name.material_color)
    assert_equal(nil, node_with_name.colors)
    assert_equal(nil, node_with_name.shininess)

    node_no_geom = Disp3D::NodeLeaf.new(nil)
    node_no_geom.material_color = [0,1,1,1]
    node_no_geom.colors = [0,0,0,1]
    node_no_geom.shininess = 30.0
    assert_equal([0,1,1,1], node_no_geom.material_color)
    assert_equal([0,0,0,1], node_no_geom.colors)
    assert_equal(30.0, node_no_geom.shininess)

    # invalid arg
    assert_raises ArgumentError do
      dmy = Disp3D::NodeLeaf.new("invalid arg")
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeLeaf.new(nil, "invalid arg")
    end
  end

end
