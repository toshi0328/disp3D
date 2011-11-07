$LOAD_PATH.unshift(File.dirname(__FILE__)
require 'helper'

MiniTest::Unit.autorun

class STLTestCase < MiniTest::Unit::TestCase
  def setup
    @file_path = File.dirname(__FILE__) + "/data/cube-ascii.stl"
    @stl = Disp3D::STL.new()
  end

  def test_parse
    @stl.parse(@file_path)
    assert_equal( "cube-ascii", @stl.name )
    assert_equal( 12, @stl.tris.size )
    assert_equal( 12, @stl.normals.size )
  end

  def test_tri_mesh
    @stl.parse(@file_path)
    tri_mesh = @stl.tri_mesh
    assert_equal( 8, tri_mesh.vertices.size )
    assert_equal( 12, tri_mesh.tri_indices.size )
    assert_equal( 6*100, tri_mesh.area )
  end

end

