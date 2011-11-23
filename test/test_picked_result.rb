$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

MiniTest::Unit.autorun

class PickedResultTestCase < MiniTest::Unit::TestCase
  def setup
    # gl initalized befor creating node
    @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    node = Disp3D::NodePoints.new(Vector3.new())
    parent_node = Disp3D::NodeCollection.new()
    parent_node.add(node)
    path_id = 5

    path_info = Disp3D::PathInfo.new(node, parent_node, path_id)
    path_info_ary = [path_info]
    screen_position = Vector3.new(1,2,0)
    world_position = Vector3.new(5.5,6.0,2.1)
    near = 0.123
    far = 0.432
    picked_result = Disp3D::PickedResult.new(path_info_ary, screen_position, world_position, near, far)

    assert_equal(1, path_info_ary.size)
    assert_equal(path_info, path_info_ary[0])
    assert_equal(screen_position, picked_result.screen_position)
    assert_equal(world_position, picked_result.world_position)
    assert_equal(near, picked_result.near)
    assert_equal(far, picked_result.far)

    assert_raises ArgumentError do
      picked_result = Disp3D::PickedResult.new(path_info, screen_position, world_position, near, far)
    end
    assert_raises ArgumentError do
      picked_result = Disp3D::PickedResult.new(path_info, 2, world_position, near, far)
    end
    assert_raises ArgumentError do
      picked_result = Disp3D::PickedResult.new(path_info, screen_position, [1,3.1,33.2], near, far)
    end
    assert_raises ArgumentError do
      picked_result = Disp3D::PickedResult.new(path_info, screen_position, world_position, nil, far)
    end
    assert_raises ArgumentError do
      picked_result = Disp3D::PickedResult.new(path_info, screen_position, world_position, near, Vector3.new())
    end

  end
end
