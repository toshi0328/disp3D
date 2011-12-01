require 'disp3D'

module Disp3D
  class NodeTris < NodeLeaf
    attr_accessor :normal_mode

    NORMAL_EACH_FACE = 0
    NORMAL_EACH_VERTEX = 1

    def initialize(geom, name = nil)
      Util3D.check_arg_type(Symbol, name, true)
      geom_inner = geom
      if(geom.kind_of?(STL))
        geom_inner = geom.tri_mesh
      end
      Util3D.check_arg_type(GMath3D::TriMesh, geom_inner, false)
      super(geom_inner, name)
      @normal_mode = NORMAL_EACH_VERTEX
    end

protected
    def draw_element
      if(@geom)
        draw_color
        if( @normal_mode == NORMAL_EACH_VERTEX && @each_vertex_normal.nil?)
          @each_vertex_normal = @geom.normals_for_each_vertices
        end

        GL.Begin(GL::TRIANGLES)
        if(@geom.kind_of?(GMath3D::TriMesh))
          @geom.triangles.each_with_index do |tri_geom, i|
            draw_colors(i)
            GL.Normal(tri_geom.normal.x, tri_geom.normal.y, tri_geom.normal.z) if(@normal_mode == NORMAL_EACH_FACE)
            tri_geom.vertices.each do |vertex|
              if(@normal_mode == NORMAL_EACH_VERTEX)
                vert_normal = @each_vertex_normal[vertex]
                GL.Normal(vert_normal.x, vert_normal.y, vert_normal.z) if(vert_normal != nil)
              end
              GL.Vertex( vertex.x, vertex.y, vertex.z )
            end
          end
        end
        GL.End()
      else
        raise
      end
    end

  end
end
