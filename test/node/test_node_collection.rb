# -*- coding: utf-8 -*-
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'helper'

MiniTest::Unit.autorun

class NodeCollectionTestCase < MiniTest::Unit::TestCase
  def setup
    # gl initalized befor creating node
    @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_add
    node_group = Disp3D::NodeCollection.new()

    node_ary = Array.new()
    node_ary[0] = Disp3D::NodeTeaPod.new()
    node_ary[1] = Disp3D::NodeLines.new(FiniteLine.new(Vector3.new(0,0,0),Vector3.new(1,1,1)))

    path_id = -1
    path_id_ary = -1
    node_group.open do
      create :type => :Points,
             :geom => Vector3.new(),
             :name => :node100

      path_id = add :node100
      path_id_ary = add node_ary
    end

    assert(node_group.include?(path_id))
    assert_equal(Disp3D::NodeDB.find_by_name(:node100), node_group.child(path_id))
    assert_equal(2, path_id_ary.size)
    path_id_ary.each do |item|
      assert(node_group.include?(item))
    end
    assert_equal(node_ary[0], node_group.child(path_id_ary[0]))
    assert_equal(node_ary[1], node_group.child(path_id_ary[1]))
    assert_equal(nil, node_group.child(-1))
  end


  def test_circular_reference
    assert_raises Disp3D::CircularReferenceException do
      Disp3D::NodeCollection.new().open do
        add_new :name => :node101 do
          add_new :name => :node102 do
            add :node101
          end
        end
      end
    end
  end

  def test_self_reference
    assert_raises Disp3D::CircularReferenceException do
      Disp3D::NodeCollection.new().open do
        add_new :name => :node101 do
          add :node101
        end
      end
    end
  end

  def test_add_new
    # TODO impliment
  end

  def test_remove
    # TODO impliment
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
