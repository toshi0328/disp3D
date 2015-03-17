require 'helper'

class NodeTrisTestCase < Minitest::Test
  def setup
    # gl initalized befor creating node
   @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    geom1 = GMath3D::TriMesh.from_box(GMath3D::Box.new())
    geom2 = GMath3D::TriMesh.from_triangles([GMath3D::Triangle.new()])
    node_with_name = Disp3D::NodeTris.new(geom1, :test)
    node_without_name = Disp3D::NodeTris.new(geom2)

    assert_equal(:test, node_with_name.name)
    assert_equal(nil, node_without_name.name)

    # invalid arg
    assert_raises ArgumentError do
      dmy = Disp3D::NodeTris.new(Box.new())
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeTris.new([geom1, geom2]) # array is not allowed
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeTris.new(geom1, Vector3.new)
    end
  end

end
