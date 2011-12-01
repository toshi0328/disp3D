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
    node_ary[0] = Disp3D::NodeTeaPod.new()
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

  def test_boundary_box
    box_geom = Box.new(Vector3.new(-1,-1,-1), Vector3.new(1,1,1))
    box_node = Disp3D::NodeTris.new(TriMesh.from_box(box_geom))
    bb = box_node.box
    assert_equal(Vector3.new(-1,-1,-1), bb.min_point)
    assert_equal(Vector3.new( 1, 1, 1), bb.max_point)

    node_collection = Disp3D::NodeCollection.new()
    node_collection.add(box_node)
    bb = node_collection.box
    assert_equal(Vector3.new(-1,-1,-1), bb.min_point)
    assert_equal(Vector3.new( 1, 1, 1), bb.max_point)

    angle_45 = 45.0 * Math::PI / 180.0
    node_collection.rotate = Quat.from_axis(Vector3.new(0,0,1), angle_45)
    bb = node_collection.box
    assert_equal(Vector3.new(-Math.sqrt(2.0),-Math.sqrt(2.0),-1), bb.min_point)
    assert_equal(Vector3.new( Math.sqrt(2.0), Math.sqrt(2.0), 1), bb.max_point)

    trans = Vector3.new(1,2,-3)
    node_collection.post_translate = trans
    bb = node_collection.box
    assert_equal(Vector3.new(-Math.sqrt(2.0),-Math.sqrt(2.0),-1) + trans, bb.min_point)
    assert_equal(Vector3.new( Math.sqrt(2.0), Math.sqrt(2.0), 1) + trans, bb.max_point)

    node_collection.pre_translate = Vector3.new(1,1,1)
    node_collection.post_translate = nil
    node_collection.rotate = nil
    bb = node_collection.box
    assert_equal(Vector3.new(0,0,0), bb.min_point)
    assert_equal(Vector3.new(2,2,2), bb.max_point)

    node_collection.rotate = Quat.from_axis(Vector3.new(1,0,0), angle_45)
    bb = node_collection.box
    assert_equal(Vector3.new(0, 0,            -Math.sqrt(2)), bb.min_point)
    assert_equal(Vector3.new(2, 2*Math.sqrt(2),Math.sqrt(2)), bb.max_point)
  end
end
