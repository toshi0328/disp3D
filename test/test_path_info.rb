$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

MiniTest::Unit.autorun

class PathInfoTestCase < MiniTest::Unit::TestCase

  def setup
    #initialize GL for create test node
    gl_view = Disp3D::GLUTWindow.new(400, 300)
  end

  def test_initalize
    node = Disp3D::NodeTeaPod.new(10)
    parent_node = Disp3D::NodeCollection.new()
    parent_node.add(node)
    path_id = 5

    path_info = Disp3D::PathInfo.new(node, parent_node, path_id)

    assert_equal(node, path_info.node)
    assert_equal(parent_node, path_info.parent_node)
    assert_equal(5, path_info.path_id)

    assert_raises ArgumentError do
      invalidResult = Disp3D::PathInfo.new(nil, parent_node, path_id)
    end
    assert_raises ArgumentError do
      invalidResult = Disp3D::PathInfo.new(node, node, path_id)
    end
    assert_raises ArgumentError do
      invalidResult = Disp3D::PathInfo.new(node, parent_node, 1.5)
    end
  end
end
