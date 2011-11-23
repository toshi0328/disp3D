require 'disp3D'

module GMath3D
  class Quat
    # convert quat to array
    def to_array
      rot_mat = Matrix.from_quat(self)
      rot_mat_array = [
        [rot_mat[0,0], rot_mat[0,1], rot_mat[0,2], 0],
        [rot_mat[1,0], rot_mat[1,1], rot_mat[1,2], 0],
        [rot_mat[2,0], rot_mat[2,1], rot_mat[2,2], 0],
        [0,0,0,1]]
      return rot_mat_array
    end
  end
end

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



