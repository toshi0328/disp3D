require 'stl_viewer'

class Document < AppModel
  def initialize()
    super()
    @tri_mesh_info_list = []
  end

  def add_tri_mesh!(tri_mesh)
    mesh_info = MeshInfo.new(tri_mesh)
    @tri_mesh_info_list.push(mesh_info)
    return mesh_info
  end
end
