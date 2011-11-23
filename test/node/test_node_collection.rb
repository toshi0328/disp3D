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



  end

  # TODO 複雑なシーングラフのテスト
end
