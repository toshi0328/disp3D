require 'disp3D'

=begin
class GL
  alias_method :Vertex_inner, :Vertex  # hold original processing
  def Vertex_new( vertex, arg2 = nil, arg3 = nil)
    if( vertex.kind_of?(Vector3))
      Vertex_inner( vertex.x, vertex.y, vertex.z )
    else
      Vertex_inner( vertex, arg2, arg3 )
    end
  alias_method :Vertex, :Vertex_new   # overwrite new multiply processing
end
=end



