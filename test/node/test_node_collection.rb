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
        add_new :name => :node111 do
          add :node111
        end
      end
    end
  end

  def test_add_new
    # test add_new
    node_group = Disp3D::NodeCollection.new()
    node_group.open do
      add_new :type => :TeaPod,
              :size => 0.5,
              :name => :node120

      add_new :type => :Points,
              :geom => Vector3.new(),
              :size => 10.0,
              :name => :node121,
              :pre_translate => Vector3.new(1,0,1),
              :post_translate => Vector3.new(1,0,1),
              :rotate => Quat.from_axis(Vector3.new(1,0,0), Math::PI)

      add_new :type => :Text,
              :geom => Vector3.new(),
              :name => :node122,
              :text => "this is node12"

      add_new :name => :node123, :post_translate => Vector3.new(1,0,1) do
        add :node120
        add_new :type => :Arrows,
                :geom => FiniteLine.new(Vector3.new(), Vector3.new(1,2,3)),
                :name => :node124
      end
    end
    assert_equal(4, node_group.child_nodes.size)
    childe_nodes_name_ary = node_group.child_nodes.collect{ |node| node.name }
    assert_equal([:node120, :node121, :node122, :node123].sort,childe_nodes_name_ary.sort)
    child_group_node = node_group.child_nodes.find{ |node| node.class == Disp3D::NodeCollection }
    assert_equal(2, child_group_node.child_nodes.size)
    childe_nodes_name_ary = child_group_node.child_nodes.collect{ |node| node.name }
    assert_equal([:node120, :node124].sort,childe_nodes_name_ary.sort)

    # remove test

    # path id DB is created by drawing
    @gl_view.world_scene_graph.add(node_group)
    @gl_view.world_scene_graph.gl_display

    path_id_120_1 = node_group.child_path_id.find{ |path_id| node_group.child(path_id).name == :node120}
    path_id_120_2 = child_group_node.child_path_id.find{ |path_id| child_group_node.child(path_id).name == :node120}
    node_group.open do
      remove path_id_120_1
    end
    assert_equal(3, node_group.child_nodes.size)
    assert_equal(2, child_group_node.child_nodes.size)

    node_group.open do
      remove path_id_120_2
    end
    assert_equal(3, node_group.child_nodes.size)
    assert_equal(1, child_group_node.child_nodes.size)

    node = Disp3D::NodeDB.find_by_name(:node120)
    assert_equal(Disp3D::NodeTeaPod, node.class)
    assert_equal(0.5,  node.size)
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
