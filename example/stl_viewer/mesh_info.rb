require 'stl_viewer'

class MeshInfo < AppModel
  attr_reader :mesh_geom
  attr_accessor :mesh_node

  def initialize(mesh)
    super()
    @mesh_geom = mesh
    @mesh_node = nil
  end

end
