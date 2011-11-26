require 'disp3D'
require 'rmagick'

module Disp3D
  class GMath3D::Quat
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

  class Magick::Image
    def to_array
      return nil if(self.nil?)
      channel_size = 3
      data_ary = Array.new(self.columns * self.rows * channel_size)
      max_color_intensity =  Magick::QuantumRange.to_f
      idx = -1
      self.each_pixel do | pixel, c, r |
        data_ary[idx+=1] = pixel.red / max_color_intensity
        data_ary[idx+=1] = pixel.green / max_color_intensity
        data_ary[idx+=1] = pixel.blue / max_color_intensity
      end
      return data_ary
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



