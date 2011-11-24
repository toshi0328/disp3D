# -*- coding: utf-8 -*-
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'helper'

MiniTest::Unit.autorun

class NodeCollectionTestCase < MiniTest::Unit::TestCase
  def setup
    # gl initalized befor creating node
    @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_add_include
    node_collection = Disp3D::NodeCollection.new()
    node_point = Disp3D::NodePoints.new(Vector3.new())
    added_id = node_collection.add(node_point)
    node_ary = Array.new()
    node_ary[0] = Disp3D::NodeTeaPod.new(4)
    node_ary[1] = Disp3D::NodeLines.new(FiniteLine.new(Vector3.new(0,0,0),Vector3.new(1,1,1)))
    added_id_ary = node_collection.add(node_ary)

    assert(node_collection.include?(added_id))
    assert_equal(node_point, node_collection.child(added_id))
    assert_equal(2, added_id_ary.size)
    added_id_ary.each do |item|
      assert(node_collection.include?(item))
    end
    assert_equal(node_ary[0], node_collection.child(added_id_ary[0]))
    assert_equal(node_ary[1], node_collection.child(added_id_ary[1]))
    assert_equal(nil, node_collection.child(-1))
  end

  def test_ancestor
    node_root = Disp3D::NodeCollection.new()
    node_child = Disp3D::NodeCollection.new()
    node_g_child = Disp3D::NodeCollection.new()
    node_root.add(node_child)
    node_child.add(node_g_child)
    ancestors = node_child.ancestors
    assert_equal(1,ancestors.size)
    assert(ancestors.include?(node_root.instance_id))

    ancestors = node_g_child.ancestors
    assert_equal(2,ancestors.size)
    assert(ancestors.include?(node_root.instance_id))
    assert(ancestors.include?(node_child.instance_id))

    node_root.add(node_g_child)
    ancestors = node_g_child.ancestors
    assert_equal(2,ancestors.size)
    assert(ancestors.include?(node_root.instance_id))
    assert(ancestors.include?(node_child.instance_id))

    node_root.add(node_child)
    ancestors = node_g_child.ancestors
    assert_equal(2,ancestors.size)
    assert(ancestors.include?(node_root.instance_id))
    assert(ancestors.include?(node_child.instance_id))

    node_g_child2 = Disp3D::NodeCollection.new()
    node_child.add(node_g_child2)
    ancestors = node_g_child2.ancestors
    assert_equal(2,ancestors.size)
    assert(ancestors.include?(node_root.instance_id))
    assert(ancestors.include?(node_child.instance_id))

    node_gg_child = Disp3D::NodeCollection.new()
    node_g_child.add(node_gg_child)
    ancestors = node_gg_child.ancestors
    assert_equal(3,ancestors.size)
    assert(ancestors.include?(node_root.instance_id))
    assert(ancestors.include?(node_child.instance_id))
    assert(ancestors.include?(node_g_child.instance_id))

    node_g_child2.add(node_gg_child)
    ancestors = node_gg_child.ancestors
    assert_equal(4,ancestors.size)
    assert(ancestors.include?(node_root.instance_id))
    assert(ancestors.include?(node_child.instance_id))
    assert(ancestors.include?(node_g_child.instance_id))
    assert(ancestors.include?(node_g_child2.instance_id))
  end

  def test_circular_reference
    node_collection1 = Disp3D::NodeCollection.new()
    node_collection2 = Disp3D::NodeCollection.new()
    node_collection3 = Disp3D::NodeCollection.new()
    node_collection1.add(node_collection2)
    node_collection2.add(node_collection3)

    # circular reference occures!
    assert_raises Disp3D::CircularReferenceException do
      node_collection3.add(node_collection1)
    end
#    @gl_view.world_scene_graph.add(node_collection1)
#    @gl_view.gl_display()
  end

  def test_self_reference
    node_collection1 = Disp3D::NodeCollection.new()
    assert_raises Disp3D::CircularReferenceException do
      node_collection1.add(node_collection1)
    end
  end

  # TODO 複雑なシーングラフのテスト
end
