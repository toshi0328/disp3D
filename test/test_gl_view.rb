$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

require 'gmath3D'

MiniTest::Unit.autorun

class GLViewTestCase < MiniTest::Unit::TestCase
  def setup
    @gl_view_has_line = Disp3D::GLUTWindow.new(300, 300)
    line_geom = GMath3D::FiniteLine.new(GMath3D::Vector3.new(0,0,0), GMath3D::Vector3.new(1,1,1))
    line_node = Disp3D::NodeLines.new(line_geom)
    line_node.width = 4
    @gl_view_has_line.world_scene_graph.add(line_node)

    @gl_view_has_point = Disp3D::GLUTWindow.new(300, 300)
    point_geom = GMath3D::Vector3.new(3,2,1)
    point_node = Disp3D::NodePoints.new(point_geom)
    point_node.size = 4
    @gl_view_has_point.world_scene_graph.add(point_node)
  end

end
