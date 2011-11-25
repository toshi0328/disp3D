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
  end

end
