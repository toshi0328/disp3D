require 'helper'

class STLTestCase < Minitest::Test
  def setup
    @file_path_ascii = File.dirname(__FILE__) + "/data/cube-ascii.stl"
    @file_path_binary = File.dirname(__FILE__) + "/data/cube-binary.stl"
    @stl = Disp3D::STL.new()
  end

  def test_parse
    success = @stl.parse(@file_path_ascii, Disp3D::STL::ASCII)
    assert_equal(success, true)
    assert_equal( "cube-ascii", @stl.name )
    assert_equal( 12, @stl.tris.size )
    assert_equal( 12, @stl.normals.size )

    success = @stl.parse(@file_path_binary, Disp3D::STL::BINARY)
    assert_equal(success, true)
    assert_equal( 12, @stl.tris.size )
    assert_equal( 12, @stl.normals.size )
  end

  def test_tri_mesh
    @stl.parse(@file_path_ascii, Disp3D::STL::ASCII)
    tri_mesh = @stl.tri_mesh
    assert_equal( 8, tri_mesh.vertices.size )
    assert_equal( 12, tri_mesh.tri_indices.size )
    assert_equal( 6*100, tri_mesh.area )
  end
end

