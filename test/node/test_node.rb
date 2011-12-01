$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'helper'

MiniTest::Unit.autorun

class NodeTestCase < MiniTest::Unit::TestCase
  def setup
    # gl initalized befor creating node
    @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    node = Disp3D::Node.new()
    assert_equal(nil, node.pre_translate)
    assert_equal(nil, node.rotate)
    assert_equal(nil, node.post_translate)

    assert_equal([], node.parents)

    assert_equal(nil, node.name)
    assert(node.instance_id.kind_of?(Integer))

    node_with_name = Disp3D::Node.new(:node00)
    assert_equal(:node00, node_with_name.name)
  end

  def test_ancestor
    node_group = Disp3D::NodeCollection.new()
    node_group.open do
      add_new :type => :Points, :geom => Vector3.new(), :name => :node01
      add_new :type => :TeaPod, :name => :node02
      add_new :type => :Text, :geom => Vector3.new(), :name => :node03
      add_new :name => :node04 do
        add_new :type => :Coord, :name => :node05
        add_new :name => :node06 do
          add_new :type => :Points, :geom => Vector3.new(), :name => :node07
          add :node01
        end
      end

      add_new :name => :node08 do
        add :node02
        add :node07
      end
    end

    root_id = node_group.instance_id
    node04_id = Disp3D::NodeDB.find_by_name(:node04).instance_id
    node06_id = Disp3D::NodeDB.find_by_name(:node06).instance_id
    node08_id = Disp3D::NodeDB.find_by_name(:node08).instance_id

    assert_equal([root_id, node04_id, node06_id].sort           , Disp3D::NodeDB.find_by_name(:node01).ancestors.sort)
    assert_equal([root_id, node08_id].sort                      , Disp3D::NodeDB.find_by_name(:node02).ancestors.sort)
    assert_equal([root_id].sort                                 , Disp3D::NodeDB.find_by_name(:node03).ancestors.sort)
    assert_equal([root_id, node04_id].sort                      , Disp3D::NodeDB.find_by_name(:node05).ancestors.sort)
    assert_equal([root_id, node04_id, node06_id, node08_id].sort, Disp3D::NodeDB.find_by_name(:node07).ancestors.sort)
  end

  def test_create
    node_group = Disp3D::NodeCollection.new()
    node_group.open do
      create :type => :TeaPod,
             :size => 0.5,
             :name => :node10

      create :type => :Points,
             :geom => Vector3.new(),
             :size => 10.0,
             :name => :node11,
             :pre_translate => Vector3.new(1,0,1),
             :post_translate => Vector3.new(1,0,1),
             :rotate => Quat.from_axis(Vector3.new(1,0,0), Math::PI)

      create :type => :Text,
             :geom => Vector3.new(),
             :name => :node12,
             :text => "this is node12"

      create :type => :Collection,
             :name => :node13,
             :pre_translate => Vector3.new(1,0,1),
             :post_translate => Vector3.new(1,0,1),
             :rotate => Quat.from_axis(Vector3.new(1,0,0), Math::PI)
    end

    node10 = Disp3D::NodeDB.find_by_name(:node10)
    assert_equal( Disp3D::NodeTeaPod, node10.class)
    assert_equal( 0.5, node10.size)

    node11 = Disp3D::NodeDB.find_by_name(:node11)
    assert_equal( Disp3D::NodePoints, node11.class)
#    assert_equal( Vector3.new, node11.geom)
    assert_equal( 10.0, node11.size)
    assert_equal( Vector3.new(1,0,1), node11.pre_translate)
    assert_equal( Vector3.new(1,0,1), node11.post_translate)
    assert_equal( Quat.from_axis(Vector3.new(1,0,0), Math::PI), node11.rotate)

    node12 = Disp3D::NodeDB.find_by_name(:node12)
    assert_equal( Disp3D::NodeText, node12.class)
    assert_equal( "this is node12", node12.text )

    node13 = Disp3D::NodeDB.find_by_name(:node13)
    assert_equal( Disp3D::NodeCollection, node13.class)
    assert_equal( Vector3.new(1,0,1), node13.pre_translate)
    assert_equal( Vector3.new(1,0,1), node13.post_translate)
    assert_equal( Quat.from_axis(Vector3.new(1,0,0), Math::PI), node13.rotate)
  end

  def test_box_trans_form
    #TODO impliment!
  end
end
