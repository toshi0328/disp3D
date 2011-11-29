require 'disp3D'

module Disp3D
  class NodeWorkplane < NodeLeaf
    attr_accessor :length

    def initialize(geom, name = nil)
      Util3D.check_arg_type(Symbol, name, true)
      Util3D.check_arg_type(GMath3D::Plane, geom, false)
      super
      @length = 1000
    end

    def box
      return Box.new(@geom.base_point)
    end

protected
    def draw_element
      if(@geom && @geom.kind_of?(GMath3D::Plane))
        draw_color
        GL.Begin(GL::QUADS)
        GL.Normal(@geom.normal.x, @geom.normal.y, @geom.normal.z)
        calc_vertices.each do |vertex|
          GL.Vertex( vertex.x, vertex.y, vertex.z )
        end
        GL.End()
      else
        raise
      end
    end

private
    def calc_vertices
      tan_vec1 = @geom.normal.arbitrary_orthogonal
      tan_vec2 = @geom.normal.cross(tan_vec1)
      vertices = Array.new(4)
      vertices[0] = @geom.base_point - tan_vec1*@length/2.0 - tan_vec2*@length/2.0
      vertices[1] = @geom.base_point + tan_vec1*@length/2.0 - tan_vec2*@length/2.0
      vertices[2] = @geom.base_point + tan_vec1*@length/2.0 + tan_vec2*@length/2.0
      vertices[3] = @geom.base_point - tan_vec1*@length/2.0 + tan_vec2*@length/2.0
      return vertices
    end
  end
end
