require 'observer'
require 'stl_viewer'

class Document
  include Observable
  attr_reader :tri_mesh
  attr_reader :tri_node

  def initialize()
    super()
    @tri_mesh = nil
    @tri_node = nil
  end

  def tri_mesh=(rhs)
    @tri_mesh = rhs
    @tri_node = Disp3D::NodeTris.new(@tri_mesh)
    changed
    notify_observers
  end
end
