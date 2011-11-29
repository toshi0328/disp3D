$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'helper'

MiniTest::Unit.autorun

class NodeTextTestCase < MiniTest::Unit::TestCase
  def setup
    # gl initalized befor creating node
   @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_initalize
    node_with_name = Disp3D::NodeText.new(Vector3.new(), :test)
    node_without_name = Disp3D::NodeText.new(Vector3.new())
    node_without_name2 = Disp3D::NodeText.new(Vector3.new(1,1,1), nil, "text to show")

    assert_equal(:test, node_with_name.name)
    assert_equal(nil, node_with_name.text)
    assert_equal(Vector3.new(), node_with_name.position)

    assert_equal(nil, node_without_name.name)
    assert_equal(nil, node_without_name.text)
    assert_equal(Vector3.new(), node_without_name.position)

    assert_equal(nil, node_without_name2.name)
    assert_equal("text to show", node_without_name2.text)
    assert_equal(Vector3.new(1,1,1), node_without_name2.position)

    # invalid arg
    assert_raises ArgumentError do
      dmy = Disp3D::NodeText.new(Box.new())
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeText.new([Vector3.new(1,0,0), Vector3.new(1,0,0)])
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeText.new(Vector3.new(1,0,0), Vector3.new())
    end
    assert_raises ArgumentError do
      dmy = Disp3D::NodeText.new(Vector3.new(1,0,0), :text, Vector3.new())
    end
  end

end
