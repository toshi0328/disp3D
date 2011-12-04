require 'disp3D'

module Disp3D
  class NodeWorkplane < NodeLeaf
    attr_for_disp :length
    attr_for_disp :grid

    def initialize(geom, name = nil)
      Util3D.check_arg_type(Symbol, name, true)
      Util3D.check_arg_type(GMath3D::Plane, geom, false)
      super
      @length = 1000
      @grid = nil
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

        GL.Color(0,0,0,1)
        GL.LineWidth(3)
        if(!@grid.nil?)
          line_vertices_ary = grid_lines_vertices
          GL.Begin(GL::LINES)
          line_vertices_ary.each do |vertex|
            GL.Vertex( vertex.x, vertex.y, vertex.z )
          end
          GL.End()
        end
      else
        raise
      end
    end

private
    def grid_lines_vertices
      count = (@length/@grid) + 1
      u_vec = @geom.normal
      u_vec = @geom.normal.arbitrary_orthogonal
      v_vec = @geom.normal.cross(u_vec)
      vertices = Array.new(count*4)
      count.times.each do |idx|
        point_tmp = @geom.base_point + u_vec * @grid * (idx - count/2)
        vertices[2*idx] = point_tmp + v_vec * @length/2.0
        vertices[2*idx+1] = point_tmp - v_vec * @length/2.0
      end
      count.times.each do |idx|
        point_tmp = @geom.base_point + v_vec * @grid * (idx - count/2)
        vertices[2*idx+2*count] = point_tmp + u_vec * @length/2.0
        vertices[2*idx+2*count+1] = point_tmp - u_vec * @length/2.0
      end
      return vertices
    end

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
