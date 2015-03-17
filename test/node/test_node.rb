require 'helper'

class NodeTestCase < Minitest::Test
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

  def test_create_and_update
    node_group = Disp3D::NodeCollection.new()
# create test
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

      create :type => :Points,
             :geom => Vector3.new,
             :name => :node14,
             :colors => [1,1,0,1]

      create :type => :Lines,
             :geom => FiniteLine.new,
             :name => :node14,
             :colors => [1,1,0,1]
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

    node14 = Disp3D::NodeDB.find_by_name(:node14)
    assert_equal( Array, node14.class)
    node14.each do |node|
      assert_equal( :node14, node.name)
      assert_equal( [1,1,0,1], node.colors)
      assert( [Disp3D::NodePoints, Disp3D::NodeLines].include?(node.class) )
    end

# update test
    node_group.open do
      update :name => :node10,
             :size => 2.0

      update :name => :node11,
             :size => 4.0,
             :geom => Vector3.new(3,2,1),
             :pre_translate => Vector3.new(1,2,3),
             :post_translate => Vector3.new(1,2,3),
             :rotate => Quat.from_axis(Vector3.new(0,1,0), Math::PI/2.0)

      update :name => :node12,
             :geom => Vector3.new(),
             :text => "this is node12 updated"

      update :name => :node13,
             :pre_translate => Vector3.new(3,2,1),
             :post_translate => Vector3.new(3,2,-1),
             :rotate => Quat.from_axis(Vector3.new(0,0,1), Math::PI)

     update :name => :node14,
             :colors => [0,1,1,1]
    end

    node10 = Disp3D::NodeDB.find_by_name(:node10)
    assert_equal( Disp3D::NodeTeaPod, node10.class)
    assert_equal( 2.0, node10.size)

    node11 = Disp3D::NodeDB.find_by_name(:node11)
    assert_equal( Disp3D::NodePoints, node11.class)
    assert_equal( 4.0, node11.size)
    assert_equal( Vector3.new(1,2,3), node11.pre_translate)
    assert_equal( Vector3.new(1,2,3), node11.post_translate)
    assert_equal( Quat.from_axis(Vector3.new(0,1,0), Math::PI/2.0), node11.rotate)

    node12 = Disp3D::NodeDB.find_by_name(:node12)
    assert_equal( Disp3D::NodeText, node12.class)
    assert_equal( "this is node12 updated", node12.text )

    node13 = Disp3D::NodeDB.find_by_name(:node13)
    assert_equal( Disp3D::NodeCollection, node13.class)
    assert_equal( Vector3.new(3,2,1), node13.pre_translate)
    assert_equal( Vector3.new(3,2,-1), node13.post_translate)
    assert_equal( Quat.from_axis(Vector3.new(0,0,1), Math::PI), node13.rotate)

    node14 = Disp3D::NodeDB.find_by_name(:node14)
    assert_equal( Array, node14.class)
    node14.each do |node|
      assert_equal( :node14, node.name)
      assert_equal( [0,1,1,1], node.colors)
      assert( [Disp3D::NodePoints, Disp3D::NodeLines].include?(node.class) )
    end
  end

  def test_box_trans_form
    node = Disp3D::Node.new
    box = Box.new
    box_org = box.clone

    node_group = Disp3D::NodeCollection.new
    node_group.pre_translate = Vector3.new(1,1,1)
    node_group.open do
      box = box_transform(box_org)
    end
    assert_equal(box_org.translate(Vector3.new(1,1,1)), box)

    rotate_quat = Quat.from_axis( Vector3.new(1,0,0), 45.0/180.0*Math::PI )
    node_group.rotate = rotate_quat
    node_group.open do
      box = box_transform(box_org)
    end
    assert_equal(box_org.translate(Vector3.new(1,1,1)).rotate(rotate_quat), box)

    node_group.post_translate = Vector3.new(-1,-1,-1)
    node_group.open do
      box = box_transform(box_org)
    end
    assert_equal(box_org.translate(Vector3.new(1,1,1)).rotate(rotate_quat).translate(Vector3.new(-1,-1,-1)), box)
  end

  def test_delete
    node_group = Disp3D::NodeCollection.new()
    node_group.open do
      create :type => :TeaPod,
             :name => :node20

      create :type => :Points,
             :geom => Vector3.new(),
             :name => :node21

      create :type => :Text,
             :geom => Vector3.new(),
             :name => :node22

      create :type => :Collection,
             :name => :node23

      create :type => :Coord,
             :name => :node23 # same name

      add :node20
      add :node21
      add :node23
    end
    assert_equal( 4, node_group.child_nodes.size)
    assert_equal( Disp3D::NodeTeaPod, Disp3D::NodeDB.find_by_name(:node20).class)
    node_ary = Disp3D::NodeDB.find_by_name(:node23)
    assert_equal( Array, node_ary.class)
    assert( node_ary.find { |node| node.class == Disp3D::NodeCollection })
    assert( node_ary.find { |node| node.class == Disp3D::NodeCoord })

    node_group.open do
      delete :node20
    end
    assert_equal( 3, node_group.child_nodes.size)
    assert_equal( nil, Disp3D::NodeDB.find_by_name(:node20))

    node_group.open do
      delete :node23
    end
    assert_equal( 1, node_group.child_nodes.size)
    assert_equal( nil, Disp3D::NodeDB.find_by_name(:node23))
  end
end
