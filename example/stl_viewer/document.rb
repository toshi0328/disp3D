require 'stl_viewer'

class Document
  def initialize
    @tri_mesh_info_list = []
    # @dirty = false
  end

  def add_tri_mesh!(tri_mesh)
    # @dirty = true
    mesh_info = MeshInfo.new(tri_mesh)
    @tri_mesh_info_list.push(mesh_info)
    return mesh_info
  end
end
